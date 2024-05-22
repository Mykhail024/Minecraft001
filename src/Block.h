#pragma once

#include <godot_cpp/variant/string.hpp>
#include <godot_cpp/variant/vector2.hpp>

#include <map>
#include <cstdint>
#include <array>

enum BLOCK_SIDE : uint8_t {
    TOP,
    BOTTOM,
    LEFT,
    RIGHT,
    FRONT,
    BACK,
};

enum BLOCK_TYPE{
    AIR,
    GRASS,
    DIRT,
    STONE
};

struct Block {
    bool solid;
    BLOCK_TYPE type;
    std::map<BLOCK_SIDE, std::array<int, 2>> offsets;
};

struct Air : public Block
{
   Air() {
       solid = false;
       type = BLOCK_TYPE::AIR;
   }
};

struct Grass : public Block
{
    Grass() {
        solid = true;
        type = BLOCK_TYPE::GRASS;
        offsets = {
            {BLOCK_SIDE::TOP, {3, 0}} ,
            {BLOCK_SIDE::BOTTOM, {1, 0}},
            {BLOCK_SIDE::RIGHT, {2, 0}},
            {BLOCK_SIDE::LEFT, {2, 0}},
            {BLOCK_SIDE::FRONT, {2, 0}},
            {BLOCK_SIDE::BACK, {2, 0}}
        };
    }
};

struct Dirt : public Block
{
    Dirt() {
        solid = true;
        type = BLOCK_TYPE::DIRT;
        offsets = {
            {BLOCK_SIDE::TOP, {1, 0}} ,
            {BLOCK_SIDE::BOTTOM, {1, 0}},
            {BLOCK_SIDE::RIGHT, {1, 0}},
            {BLOCK_SIDE::LEFT, {1, 0}},
            {BLOCK_SIDE::FRONT, {1, 0}},
            {BLOCK_SIDE::BACK, {1, 0}}
        };
    }
};

struct Stone : public Block
{
    Stone() {
        solid = true;
        type = BLOCK_TYPE::STONE;
        offsets = {
            {BLOCK_SIDE::TOP, {0, 0}} ,
            {BLOCK_SIDE::BOTTOM, {0, 0}},
            {BLOCK_SIDE::RIGHT, {0, 0}},
            {BLOCK_SIDE::LEFT, {0, 0}},
            {BLOCK_SIDE::FRONT, {0, 0}},
            {BLOCK_SIDE::BACK, {0, 0}}
        };
    }
};

Block* stone_ptr();
Block* dirt_ptr();
Block* grass_ptr();
Block* air_ptr();



