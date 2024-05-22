#pragma once

#include "godot_cpp/classes/material.hpp"
#include "godot_cpp/variant/array.hpp"
#include "godot_cpp/variant/vector2.hpp"
#include "godot_cpp/variant/vector3.hpp"
#include "godot_cpp/classes/mesh_instance3d.hpp"
#include <godot_cpp/classes/array_mesh.hpp>
#include <godot_cpp/classes/base_material3d.hpp>
#include <godot_cpp/variant/packed_vector3_array.hpp>
#include <godot_cpp/variant/packed_vector2_array.hpp>

#include "Block.h"

namespace godot {
class Chunk : public MeshInstance3D
{
    GDCLASS(Chunk, MeshInstance3D)

    public:
        Chunk();
        ~Chunk();
        void _ready() override;
        void generate();
        void update();
        void commit();
        bool check_transparent(const Vector3 &cord);
        void create_block(const Vector3 &cord);
        void create_face(const Array &side, const Vector3 &offset, const Vector2 &texture_atlas_offset);
        void set_chunk(const Vector2 &pos);

        void set_material(BaseMaterial3D *material);
        BaseMaterial3D* get_material();

    protected:
        static void _bind_methods();

    private:
        PackedVector3Array verts;
        PackedVector3Array normals;
        PackedVector3Array indices;
        PackedVector2Array uvs;

        Array m_mesh_array;
        ArrayMesh *m_mesh;
        BaseMaterial3D *m_material;

        Block m_blocks[16][256][16];
};
}
