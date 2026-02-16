// --------------------------------
// Purpose: Object representing a cuboid volume in world.
// --------------------------------


#include "VolumeInterface.as"
#include "CuboidVolumeSimple.as"

class CuboidVolume : CuboidVolumeSimple {

    protected QAngle rotation;
    protected matrix3x4_t RotationMatrix;

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
    
    // Initialize mixin functionality from Min, Max vectors, optional origin vector = [0, 0, 0] and rotation vector = [0, 0, 0] is used to orient this volume in space.
    protected void InitVolume(Vector Min, Vector Max, Vector origin = Vector(0, 0, 0), QAngle rotation = QAngle(0, 0, 0)) {
        CuboidVolumeSimple::InitVolume(Min, Max, origin);
        this.SetRotation(rotation);
    }

    // Initialize mixin functionality from dimensions x, y ,z, optional origin vector = [0, 0, 0] and rotation vector = [0, 0, 0] is used to orient this volume in space.
    protected void InitVolume(double length_x, double length_y, double length_z, Vector origin = Vector(0, 0, 0)) {
        CuboidVolumeSimple::InitVolume(length_x, length_y, length_z, origin);
        this.SetRotation(rotation);
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

}