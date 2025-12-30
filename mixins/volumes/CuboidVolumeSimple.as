// --------------------------------
// Purpose: Object representing a simple (axis alligned) cuboid volume in world.
// --------------------------------


// Represents an axis alligned cuboid volume in world.
class CuboidVolumeSimple {

    protected uint len_x, len_y, len_z;
    
    protected Vector origin;


    // Construct from Min, Max vectors, optional origin vector = [0, 0, 0] is used to orient this volume in space.
    CuboidVolumeSimple(Vector Min, Vector Max, Vector origin = Vector()) { // FIX: this Vector creation, currently vector might not be correctly bound to AS
        this.len_x = abs(Max[0] - Min[0]);
        this.len_y = abs(Max[1] - Min[1]);
        this.len_z = abs(Max[2] - Min[2]);

        this.origin = origin;
    }

    // Construct from dimensions x, y ,z, optional origin vector = [0, 0, 0] is used to orient this volume in space.
    CuboidVolumeSimple(uint length_x, uint length_y, uint length_z, Vector origin = Vector()) { // FIX: Ditto
        this.len_x = length_x;
        this.len_y = length_y;
        this.len_z = length_z;
        
        this.origin = origin;
    }

    // Set the length in the X axis.
    void SetLengthX(uint len) {
        this.len_x = len;
    }

    // Set the length in the Y axis.
    void SetLengthY(uint len) {
        this.len_y = len;
    }

    // Set the length in the Z axis.
    void SetLengthZ(uint len) {
        this.len_z = len;
    }

    // Scale the whole object by this value.
    void Scale(uint s) {
        this.len_x *= s;
        this.len_y *= s;
        this.len_z *= s;
    }

    // Scale length in the X axis by this value.
    void ScaleX(uint s) {
        this.len_x *= s;
    }

    // Scale length in the Y axis by this value.
    void ScaleY(uint s) {
        this.len_y *= s;
    }

    // Scale length in the Z axis by this value.
    void ScaleZ(uint s) {
        this.len_z *= s;
    }

    // Get this volume's origin.
    Vector GetOrigin() {
        return this.origin;
    }

    // Set this volume's origin.
    void SetOrigin(Vector origin) {
        this.origin = origin;
    }

    // Like GetOrigin, but this returns the geometrical center of this cuboid
    Vector GetCenter() {
        Vector local_origin;
        local_origin.Init(len_x / 2, len_y / 2, len_z / 2);

        return this.origin + local_origin;
    }

    // Checks if this vector is inside of this volume
    bool IsInVolume(Vector v) {
        Vector localized_v = v - this.origin; // In our local space

        return (
            v[0] > 0 && v[0] < this.len_x &&
            v[1] > 0 && v[1] < this.len_y &&
            v[2] > 0 && v[2] < this.len_z
        );
    }

}
