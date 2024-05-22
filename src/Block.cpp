#include "Block.h"

Block* stone_ptr()
{
    static Stone *INSTANCE = new Stone;
    return INSTANCE;
}

Block* dirt_ptr()
{
    static Dirt *INSTANCE = new Dirt;
    return INSTANCE;
}

Block* grass_ptr()
{
    static Grass *INSTANCE = new Grass;
    return INSTANCE;
}

Block* air_ptr()
{
    static Air *INSTANCE = new Air;
    return INSTANCE;
}
