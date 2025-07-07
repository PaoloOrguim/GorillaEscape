#ifndef COLLISIONS_H
#define COLLISIONS_H
#include <glm/glm.hpp>

bool collisionCheckBoxSphere(
    const glm::vec3& boxCenter,
    const glm::vec3& boxSize,
    const glm::vec3& sphereCenter,
    float sphereRadius
);

bool collisionCheckCircleLine(
    const glm::vec2& lineStart,
    const glm::vec2& lineEnd,
    const glm::vec2& circleCenter,
    float circleRadius
);

bool collisionCheckBuilding(
    const glm::vec2& playerCandidatePosition,
    int buildingIndex
);

int collisionCheckDoors(
    const glm::vec2& playerPosition,
    int buildingIndex,
    float collisionRadius
);

bool collisionCheckCircleCircle(const glm::vec2& centerA, float radiusA,
                                const glm::vec2& centerB, float radiusB);

/*
Paredes do prédio na origem (vértice inicial / vértice final)
Paredes externas:
X: 1.56; Z: 10.50 / X: 1.56; Z: -12.84
X: 1.56; Z: -12.84 / X: -1.56; Z: -12.86
X: -1.56; Z: -12.86 / X: -3.12; Z: -12.87 (PORTA!!!) porta indice 1
X: -3.12; Z: -12.87 / X: -6.16; Z: -12.89
X: -6.16; Z: -12.89 / X: -6.16; Z: 10.44
X: -6.16; Z: 10.44 / X: -3.11; Z: 10.47
X: -3.11; Z: 10.47 / X: -1.56; Z: 10.50 (PORTA !!!) porta indice 0
X: -1.56; Z: 10.50 / X: 1.56; Z: 10.50
Paredes internas:
X: -1.56; Z: 10.50 / X: -1.56; Z: 4.65
X: -1.56; Z: 3.87 / X: -1.46; Z: -2.72
X: -1.47; Z: -3.50 / X: -1.47; Z: -10.11
X: -1.47; Z: -10.89 / X: -1.47; Z: -12.78
X: -1.38; Z: -11.27 / X: 1.53; Z: -11.27
X: 1.53; Z: -4.28 / X: -1.38; Z: -4.28
X: -1.38; Z: -3.89 / X: 1.53; Z: -3.89
X: 1.53; Z: 3.11 / X: -1.38; Z: 3.11
X: -1.38; Z: 3.48 / X: 1.53; Z: 3.48
X: -3.17; Z: 10.48 / X: -3.20; Z: 4.65
X: -3.20; Z: 3.87 / X: -3.20; Z: -2.72
X: -3.20; Z: -3.50 / X: -3.20; Z: -10.11
X: -3.20; Z: -10.89 / X: -3.20; Z: -12.84
X: -3.29; Z: -11.27 / X: -6.13; Z: -11.33
X: -6.13; Z: -4.34 / X: -3.29; Z: -4.28
X: -3.29; Z: -3.89 / X: -6.13; Z: -3.94
X: -6.13; Z: 3.05 / X: -3.29; Z: 3.11
X: -3.29; Z: 3.48 / X: -6.13; Z: 3.43
*/

#endif // COLLISIONS_H