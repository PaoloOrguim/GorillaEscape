#include "collisions.h"
#include <algorithm>
#include <cstdio>   // Only for the printf function
#include <vector>
#include <utility>  // For std::pair

// Function to check collision between an axis-aligned bounding box (AABB)
// and a sphere
// The parameters are:
// - boxCenter: coordinates of the center of the box (x, y, z)
// - boxSize: size of the box sides (width, height, depth)
// - sphereCenter: coordinates of the center of the sphere (x, y, z)
// - sphereRadius: radius of the sphere
// Based on the algorithm described in
// https://developer.mozilla.org/en-US/docs/Games/Techniques/3D_collision_detection
bool collisionCheckBoxSphere(
    const glm::vec3& boxCenter,
    const glm::vec3& boxSize,
    const glm::vec3& sphereCenter,
    float sphereRadius
)
{
    float minX = boxCenter.x - boxSize.x / 2.0f;
    float maxX = boxCenter.x + boxSize.x / 2.0f;
    float minY = boxCenter.y - boxSize.y / 2.0f;
    float maxY = boxCenter.y + boxSize.y / 2.0f;
    float minZ = boxCenter.z - boxSize.z / 2.0f;
    float maxZ = boxCenter.z + boxSize.z / 2.0f;

    // We use the clamping technique to find the closest point on the box
    float x = std::max(minX, std::min(sphereCenter.x, maxX));
    float y = std::max(minY, std::min(sphereCenter.y, maxY));
    float z = std::max(minZ, std::min(sphereCenter.z, maxZ));

    float distanceSquared = (x - sphereCenter.x) * (x - sphereCenter.x) +
                            (y - sphereCenter.y) * (y - sphereCenter.y) +
                            (z - sphereCenter.z) * (z - sphereCenter.z);

    return distanceSquared <= (sphereRadius * sphereRadius);
}

bool collisionCheckCircleLine(
    const glm::vec2& lineStart,
    const glm::vec2& lineEnd,
    const glm::vec2& circleCenter
) {
    float circleRadius = 0.1f;
    glm::vec2 AB = lineEnd   - lineStart;
    glm::vec2 AC = circleCenter - lineStart;

    // project AC onto AB, get t
    float t = glm::dot(AC, AB) / glm::dot(AB, AB);

    // clamp t to [0,1] using glm::clamp on a scalar
    t = glm::clamp(t, 0.0f, 1.0f);

    glm::vec2 closestPoint = lineStart + t * AB;
    float dist2 = glm::dot(circleCenter - closestPoint,
                           circleCenter - closestPoint);

    return dist2 <= circleRadius * circleRadius;
}

// Function that iterates through every wall from a specific building
// and checks if the player is colliding with any of them.
// It receives the player's position and the index from the specific building
// Each building has an offset from the origin and a rotation which have to be considered
// when checking for collisions.
bool collisionCheckBuilding(
    const glm::vec2& playerCandidatePosition,
    int buildingIndex
) {
    // Vector of pairs containing the start and end points of each wall
    // from the center building, offsets will be determined from there
    static const std::vector<std::pair<glm::vec2, glm::vec2>> walls = {
        // Doors are not included in this list
        // Outside walls
        {{1.56f, 10.50f}, {1.56f, -12.84f}},
        {{1.56f, -12.84f}, {-1.56f, -12.86f}},
        {{-3.12f, -12.87f}, {-6.16f, -12.89f}},
        {{-6.16f, -12.89f}, {-6.16f, 10.44f}},
        {{-6.16f, 10.44f}, {-3.11f, 10.47f}},
        {{-1.56f, 10.50f}, {1.56f, 10.50f}},
        // Inside walls
        {{-1.56f, 10.50f}, {-1.56f, 4.65f}},
        {{-1.56f, 3.87f}, {-1.46f, -2.72f}},
        {{-1.47f, -3.50f}, {-1.47f, -10.11f}},
        {{-1.47f, -10.89f}, {-1.47f, -12.78f}},
        {{-1.38f, -11.27f}, {1.53f, -11.27f}},
        {{1.53f, -4.28f}, {-1.38f, -4.28f}},
        {{-1.38f, -3.89f}, {1.53f, -3.89f}},
        {{1.53f, 3.11f}, {-1.38f, 3.11f}},
        {{-1.38f, 3.48f}, {1.53f,3.48f}},
        {{-3.17f,10.48f},{-3.20f,4.65f}},
        {{-3.20f, 3.87f},{-3.20f,-2.72f}},
        {{-3.20f,-3.50f},{-3.20f,-10.11f}},
        {{-3.20f,-10.89f},{-3.20f,-12.84f}},
        {{-3.29f,-11.27f},{-6.13f,-11.33f}},
        {{-6.13f,-4.34f},{-3.29f,-4.28f}},
        {{-3.29f,-3.89f},{-6.13f,-3.94f}},
        {{-6.13f,3.05f},{-3.29f,3.11f}},
        {{-3.29f,3.48f},{-6.13f,3.43f}}
    };

    // If the building index is not 0, we need to apply an offset
    // and a rotation to the walls vector.
    // The offset and rotation are both determined by the building index

    glm::vec2 offset = glm::vec2(0.0f, 0.0f);
    float rotationAngle = 0.0f;
    switch (buildingIndex) {
        case 0:
            // No offset or rotation for the center building
            break;
        case 1:
            offset = glm::vec2(17.5f, 0.0f);
            // No rotation for the second building
            break;
        case 2:
            offset = glm::vec2(-17.5f, 0.0f);
            // No rotation for the third building
            break;
        case 3:
            offset = glm::vec2(14.0f, 21.0f);
            // 90 degrees rotation for the fourth building
            rotationAngle = glm::radians(90.0f);
            break;
        case 4:
            offset = glm::vec2(-14.0f, 21.0f);
            // 90 degrees rotation for the fifth building
            rotationAngle = glm::radians(90.0f);
            break;
        default:
            return false; // Invalid building index, no collision check
    }
    float c = glm::cos(rotationAngle), s = glm::sin(rotationAngle);
    glm::mat2 R(c, -s,
                s,  c);

    // 4) Transform each base segment into world space and test collision
    for (auto const& seg : walls) {
        glm::vec2 a = R * seg.first  + offset;
        glm::vec2 b = R * seg.second + offset;

        if (collisionCheckCircleLine(a, b, playerCandidatePosition))
            return true;
    }
    // If no collision was detected, we return false
    return false;
}


// Function that checks if the player is colliding with any of the doors
// It receives the player's position and the index from the specific building the players is closest to
// Each building has two doors, one on each side of the building
// The doors are defined as pairs of points, each representing the start and end of a line
// segment, and the function checks if the player is colliding with any of them
// The function returns 0 if the player collides with the even indexed door,
// 1 if the player collides with the odd indexed door, and -1 if there
// is no collision with any door.
int collisionCheckDoors(
     const glm::vec2& playerPosition,
     int buildingIndex
){
    static const std::vector<std::pair<glm::vec2, glm::vec2>> doors = {
        // Doors
        {{-3.11f, 10.47f}, {-1.56f, 10.50f}},    // Even index
        {{-1.56f, -12.86f}, {-3.12f, -12.87f}}   // Odd index
    };

    glm::vec2 offset = glm::vec2(0.0f, 0.0f);
    float rotationAngle = 0.0f;
    switch (buildingIndex) {
        case 0:
            // No offset or rotation for the center building
            break;
        case 1:
            offset = glm::vec2(17.5f, 0.0f);
            // No rotation for the second building
            break;
        case 2:
            offset = glm::vec2(-17.5f, 0.0f);
            // No rotation for the third building
            break;
        case 3:
            offset = glm::vec2(14.0f, 21.0f);
            // 90 degrees rotation for the fourth building
            rotationAngle = glm::radians(90.0f);
            break;
        case 4:
            offset = glm::vec2(-14.0f, 21.0f);
            // 90 degrees rotation for the fifth building
            rotationAngle = glm::radians(90.0f);
            break;
        default:
            return -1; // Invalid building index, no collision check
    }

    float c = glm::cos(rotationAngle), s = glm::sin(rotationAngle);
    glm::mat2 R(c, -s,
                s,  c);

    
    // We iterate through the doors vector and check for collisions
    // If we find a collision with the first door, we return 0
    // If we find a collision with the second door, we return 1
    for (size_t i = 0; i < doors.size(); ++i) {
        const auto& seg = doors[i];
        glm::vec2 a = R * seg.first  + offset;
        glm::vec2 b = R * seg.second + offset;
        if (collisionCheckCircleLine(a, b, playerPosition)) {
            return int(i);  // retorna 0 ou 1 conforme o índice
        }
    }
    // If no collision was detected, we return -1
    return -1;
}