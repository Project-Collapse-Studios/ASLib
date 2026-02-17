
interface VolumeInterface {
    // Checks if this vector is inside of this volume
    bool IsInVolume(Vector v);

    // Get the scalar of this volume in u^3
    double GetVolume();

    // Get this volume's origin.
    Vector GetOrigin();

    // Set this volume's origin.
    void SetOrigin(Vector origin);

    // Get the Max vector of AABB
    Vector GetAABBMax();

    // Get the Min vector of AABB
    Vector GetAABBMin();
}