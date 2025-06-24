#include "collisions.h"
#include <algorithm>
#include <cstdio>   // Only for the printf function

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
    float circleRadius = 0.2f;
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


// The following functions are commented out because they are not used in the current implementation.
// They were used as initial ideas for collision detection, but the current implementation uses a different approach.
// bool pointCircle(
//     const glm::vec2& point,
//     const glm::vec2& circleCenter,
//     float circleRadius
// ) {
//     float distX = point.x - circleCenter.x;
//     float distY = point.y - circleCenter.y;
//     float distSquared = (distX * distX + distY * distY);
//     if (distSquared <= (circleRadius * circleRadius))
//         return true;
//     return false;
// }

// bool linePoint(
//     const glm::vec2& lineStart,
//     const glm::vec2& lineEnd,
//     const glm::vec2& point
// ) {
//     float d1 = glm::distance(lineStart, point);
//     float d2 = glm::distance(lineEnd, point);

//     float lineLength = glm::distance(lineStart, lineEnd);
//     float buffer = 0.01f; // Small buffer to account for floating point precision
//     if (d1 + d2 >= lineLength - buffer && d1 + d2 <= lineLength + buffer) {
//         // The point is on the line segment
//         return true;
//     }
//     return false; // The point is not on the line segment
// }

// bool collisionCheckCircleLine(
//     const glm::vec2& lineStart,
//     const glm::vec2& lineEnd,
//     const glm::vec2& circleCenter
// ) {
//     float circleRadius = 0.3f; // Hardcoded radius for the player box
    
//     bool inside1 = pointCircle(lineStart, circleCenter, circleRadius);
//     bool inside2 = pointCircle(lineEnd, circleCenter, circleRadius);
//     if (inside1 || inside2) {
//         return true; // One of the endpoints is inside the circle
//     }

//     float distX = lineStart.x - lineEnd.x;
//     float distY = lineStart.y - lineEnd.y;
//     float lenSquared = distX * distX + distY * distY;

//     float dot = ( ((circleCenter.x - lineStart.x)*(lineEnd.x-lineStart.x)) + ((circleCenter.y - lineStart.y)*(lineEnd.y - lineStart.y)) ) / (lenSquared);

//     float closestX = lineStart.x + dot * (lineEnd.x - lineStart.x);
//     float closestY = lineStart.y + dot * (lineEnd.y - lineStart.y);

//     bool onSegment = linePoint(lineStart, lineEnd, glm::vec2(closestX, closestY));
//     if (!onSegment) {
//         return false; // Closest point is not on the segment
//     }

//     distX = closestX - circleCenter.x;
//     distY = closestY - circleCenter.y;
//     float distSquared = distX * distX + distY * distY;
//     return distSquared <= (circleRadius * circleRadius);
// }