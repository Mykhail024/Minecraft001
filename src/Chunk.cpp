#include "Chunk.h" 

#include "godot_cpp/classes/array_mesh.hpp"
#include <godot_cpp/classes/base_material3d.hpp>
#include <godot_cpp/classes/global_constants.hpp>
#include <godot_cpp/classes/material.hpp>
#include <godot_cpp/core/object.hpp>
#include <godot_cpp/core/property_info.hpp>
#include <godot_cpp/variant/variant.hpp>

using namespace godot;

void Chunk::_bind_methods()
{
	ClassDB::bind_method(D_METHOD("get_material"), &Chunk::get_material);
	ClassDB::bind_method(D_METHOD("set_material", "p_material"), &Chunk::set_material);
    ClassDB::add_property("Chunk", PropertyInfo(Variant::OBJECT, "material", PROPERTY_HINT_RESOURCE_TYPE, "BaseMaterial3D"), "set_material", "get_material");
}

Chunk::Chunk()
{
    m_mesh_array.resize(ArrayMesh::ARRAY_MAX);
}

Chunk::~Chunk()
{

}

void Chunk::_ready()
{
    generate();
    update();
}

void Chunk::generate()
{

}

void Chunk::update()
{

}

void Chunk::commit()
{

}

bool check_transparent(const Vector3 &cord)
{

}

void Chunk::create_block(const Vector3 &cord)
{

}

void Chunk::create_face(const Array &side, const Vector3 &offset, const Vector2 &texture_atlas_offset)
{

}

void Chunk::set_chunk(const Vector2 &pos)
{

}

void Chunk::set_material(BaseMaterial3D *material)
{
    m_material = material;
}

BaseMaterial3D* Chunk::get_material()
{
    return m_material;
}
