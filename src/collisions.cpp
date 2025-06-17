#include "collisions.h"
#include <algorithm>

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