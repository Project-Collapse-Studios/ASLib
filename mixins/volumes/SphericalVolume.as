// --------------------------------
// Purpose: Object representing a spherical volume in world.
// --------------------------------

#include "VolumeInterface.as"

mixin class SphericalVolume : VolumeInterface {

    protected double radius;
    protected Vector origin;

    // Initialize from radius. Optional origin = [0, 0, 0] to orient the volume in space.
    protected void InitVolume(double radius, Vector origin = Vector(0,0,0))  {
        this.radius = radius;
        this.origin = origin;
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
        
    }
}