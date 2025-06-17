#ifndef COLLISIONS_H
#define COLLISIONS_H
#include <glm/glm.hpp>

bool collisionCheckBoxSphere(
    const glm::vec3& boxCenter,
    const glm::vec3& boxSize,
    const glm::vec3& sphereCenter,
    float sphereRadius
);

#endif // COLLISIONS_H