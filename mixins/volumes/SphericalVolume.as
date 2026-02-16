// --------------------------------
// Purpose: Object representing a spherical volume in world.
// --------------------------------

#include "VolumeInterface.as"
#include "../../math/constants.as"

mixin class SphericalVolume : VolumeInterface {

    protected double radius;
    protected Vector origin;

    // Initialize from radius. Optional origin = [0, 0, 0] to orient the volume in space.
    protected void InitVolume(double radius, Vector origin = Vector(0,0,0))  {
        this.radius = abs(radius);
        this.origin = origin;
    }

    void SetRadius(double r) {
        this.radius = abs(r);
    }

    double GetRadius() {
        return this.radius;
    }

    // Set this volumes origin.
    void SetOrigin(Vector v) {
        this.origin = v;
    }

    // Get this volumes origin.
    Vector GetOrigin() {
        return this.origin;
    }

    // Get the scalar of this volume in u^3
    double GetVolume() {
        return (radius * radius * radius * PI * 4) / 3;
    }

    // Checks if this vector is inside of this volume
    bool IsInVolume(Vector v) {
        v -= this.origin; // In our local space
        return v.LengthSqr() <= this.radius * this.radius; // We can save on the sqrt operation
    }
}