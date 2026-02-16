
interface VolumeInterface {
    // Checks if this vector is inside of this volume
    bool IsInVolume(Vector v);

    // Get the scalar of this volume in u^3
    double GetVolume();

    // Get this volumes origin.
    Vector GetOrigin();

    // Set this volumes origin.
    void SetOrigin(Vector origin);
}