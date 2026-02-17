// --------------------------------
// Purpose: Object representing a cuboid volume in world.
// --------------------------------


#include "VolumeInterface.as"
#include "CuboidVolumeSimple.as"
#include "../../math/basic_functions.as"

// Implements a cuboid volume with rotation in the world
class CuboidVolume : CuboidVolumeSimple {

    protected QAngle rotation;
    protected matrix3x4_t RotationMatrix;

    // === CONSTRUCTORS ===
    CuboidVolume() {
        super(0, 0, 0, Vector(0, 0, 0));
        this.SetRotation(QAngle(0, 0, 0));
    }

    // Initialize mixin functionality from Min, Max vectors, optional origin vector = [0, 0, 0] and rotation vector = [0, 0, 0] is used to orient this volume in space.
    CuboidVolume(Vector Min, Vector Max, Vector origin = Vector(0, 0, 0), QAngle rotation = QAngle(0, 0, 0)) {
        super(Min, Max, origin);
        this.SetRotation(rotation);
    }

    // Initialize mixin functionality from dimensions x, y ,z, optional origin vector = [0, 0, 0] and rotation vector = [0, 0, 0] is used to orient this volume in space.
    CuboidVolume(double length_x, double length_y, double length_z, Vector origin = Vector(0, 0, 0)) {
        super(length_x, length_y, length_z, origin);
        this.SetRotation(rotation);
    }
    
    // === END ===

    // Set the rotation to this value
    void SetRotation(QAngle rot) {
        this.rotation = rot;
        this.RotationMatrix.InitFromQAngles(this.rotation);
    }

    // Rotate this volume
    void Rotate(QAngle rot) {
        this.rotation += rot;
        this.RotationMatrix.InitFromQAngles(this.rotation);
    }

    // Get the Max vector of AABB
    Vector GetAABBMax() {
        // Bottom plane
        Vector v0 = Vector(-this.len_x / 2, -this.len_y/2, -this.len_z/2);
        Vector v1 = Vector(this.len_x / 2, -this.len_y/2, -this.len_z/2);
        Vector v2 = Vector(this.len_x / 2, this.len_y/2, -this.len_z/2);
        Vector v3 = Vector(-this.len_x / 2, this.len_y/2, -this.len_z/2);

        // Upper plane
        Vector v4 = -v2;
        Vector v5 = -v3;
        Vector v6 = -v0;
        Vector v7 = -v1;

        v0 = this.BASIS_LocalToCanonical(v0);
        v1 = this.BASIS_LocalToCanonical(v1);
        v2 = this.BASIS_LocalToCanonical(v2);
        v3 = this.BASIS_LocalToCanonical(v3);
        v4 = this.BASIS_LocalToCanonical(v4);
        v5 = this.BASIS_LocalToCanonical(v5);
        v6 = this.BASIS_LocalToCanonical(v6);
        v7 = this.BASIS_LocalToCanonical(v7);


        v1.x = math::max({v0.x, v1.x, v2.x, v3.x, v4.x, v5.x, v6.x, v7.x});
        v1.y = math::max({v0.x, v1.y, v2.y, v3.y, v4.y, v5.y, v6.y, v7.y});
        v1.z = math::max({v0.x, v1.z, v2.z, v3.z, v4.z, v5.z, v6.z, v7.z});
        return v1;
    }

    // Transform a vector from being represented in the canonical (world) basis to local (rotated) basis.
    private Vector BASIS_CanonicalToLocal(Vector v) {
        return this.RotationMatrix.RotateVector(v);
    }

    // Transform a vector from being represented in the local (rotated) basis to the canonical (world) basis.
    private Vector BASIS_LocalToCanonical(Vector v) {
        // Rotation matrices are linear isometries, I assume the determinant is not equal to 0
        return this.RotationMatrix.RotateVectorByInverse(v);
    }

    // Checks if this vector is inside of this volume
    bool IsInVolume(Vector v) {
        v -= this.origin; // In our local space
        v = this.BASIS_CanonicalToLocal(v);
        return ( // Edges also belong to the volume
            v[0] >= -this.len_x/2 && v[0] <= this.len_x/2 &&
            v[1] >= -this.len_y/2 && v[1] <= this.len_y/2 &&
            v[2] >= -this.len_z/2 && v[2] <= this.len_z/2
        );
    }

#if DEBUG
    void Visualize() {
        if (this.visualizers.length() < 8) {
            return;
        }
        
        // Bottom plane
        Vector v0 = Vector(-this.len_x / 2, -this.len_y/2, -this.len_z/2);
        Vector v1 = Vector(this.len_x / 2, -this.len_y/2, -this.len_z/2);
        Vector v2 = Vector(this.len_x / 2, this.len_y/2, -this.len_z/2);
        Vector v3 = Vector(-this.len_x / 2, this.len_y/2, -this.len_z/2);

        // Upper plane
        Vector v4 = -v2;
        Vector v5 = -v3;
        Vector v6 = -v0;
        Vector v7 = -v1;

        v0 = this.BASIS_LocalToCanonical(v0);
        v1 = this.BASIS_LocalToCanonical(v1);
        v2 = this.BASIS_LocalToCanonical(v2);
        v3 = this.BASIS_LocalToCanonical(v3);
        v4 = this.BASIS_LocalToCanonical(v4);
        v5 = this.BASIS_LocalToCanonical(v5);
        v6 = this.BASIS_LocalToCanonical(v6);
        v7 = this.BASIS_LocalToCanonical(v7);

        Msg("Vectors done!");

        //auto@ ent = this.visualizers[0];
        //if (@ent == null) {
        //    Msg("Ent is null!");
        //}
        //Msg("Found ent: " + en);
        //this.visualizers[0].SetAbsOrigin(v0 + this.origin);
        //this.visualizers[1].SetAbsOrigin(v1 + this.origin);
        //this.visualizers[2].SetAbsOrigin(v2 + this.origin);
        //this.visualizers[3].SetAbsOrigin(v3 + this.origin);
        //this.visualizers[4].SetAbsOrigin(v4 + this.origin);
        //this.visualizers[5].SetAbsOrigin(v5 + this.origin);
        //this.visualizers[6].SetAbsOrigin(v6 + this.origin);
        //this.visualizers[7].SetAbsOrigin(v7 + this.origin);
        EntityList().FindByName(null,"DEBUG_LASER_1").SetAbsOrigin(v0 + this.origin);
        EntityList().FindByName(null,"DEBUG_LASER_2").SetAbsOrigin(v1 + this.origin);
        EntityList().FindByName(null,"DEBUG_LASER_3").SetAbsOrigin(v2 + this.origin);
        EntityList().FindByName(null,"DEBUG_LASER_4").SetAbsOrigin(v3 + this.origin);
        EntityList().FindByName(null,"DEBUG_LASER_5").SetAbsOrigin(v4 + this.origin);
        EntityList().FindByName(null,"DEBUG_LASER_6").SetAbsOrigin(v5 + this.origin);
        EntityList().FindByName(null,"DEBUG_LASER_7").SetAbsOrigin(v6 + this.origin);
        EntityList().FindByName(null,"DEBUG_LASER_8").SetAbsOrigin(v7 + this.origin);
    }
#endif

}