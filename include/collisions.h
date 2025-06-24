#ifndef COLLISIONS_H
#define COLLISIONS_H
#include <glm/glm.hpp>

bool collisionCheckBoxSphere(
    const glm::vec3& boxCenter,
    const glm::vec3& boxSize,
    const glm::vec3& sphereCenter,
    float sphereRadius
);

// bool pointCircle(
//     const glm::vec2& point,
//     const glm::vec2& circleCenter,
//     float circleRadius
// );

// bool linePoint(
//     const glm::vec2& lineStart,
//     const glm::vec2& lineEnd,
//     const glm::vec2& point
// );

bool collisionCheckCircleLine(
    const glm::vec2& lineStart,
    const glm::vec2& lineEnd,
    const glm::vec2& circleCenter
);

#endif // COLLISIONS_H