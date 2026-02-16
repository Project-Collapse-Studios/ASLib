// --------------------------------
// Purpose: Object representing a cylindrical volume in world.
// --------------------------------

#include "VolumeInterface.as"
#include "../../math/ParametricLine.as"

class CylindricalVolume : VolumeInterface {

    protected double radius, length;
    protected Vector dir;
    protected Vector origin;

    // Line that represents the center of the cylinder and it's direction
    protected ParametricLine centerline;

    // === CONSTRUCTORS ===

    // Initialize from radius, length and direction vector. Optional origin vector used to orient this volume in space.
    CylindricalVolume(double radius, double length, Vector dir_vec, Vector origin = Vector(0, 0, 0)) {
        this.radius = radius;
        this.length = length;
        this.dir = dir_vec.Normalized();
        this.origin = origin;

        this.UpdateCenterline();
    }

    // === SETTERS ===

    void SetRadius(double r) {
        this.radius = r;
    }

    void SetLength(double l) {
        this.length = l;
    }

    // Set the direction vector (orientation) of this cylinder
    void SetDirVec(Vector dir) {
        this.dir = dir.Normalized();
        this.UpdateCenterline();
    }

    void SetOrigin(Vector origin) {
        this.origin = origin;
        this.UpdateCenterline();
    }

    // === GETTERS ===

    double GetRadius() {
        return this.radius;
    }

    double GetLength() {
        return this.length;
    }

    Vector GetDirVec() {
        return this.dir;
    }

    Vector GetOrigin() {
        return this.origin;
    }


    // === OTHER METHODS ===

    // Update center line to reflect internal changes.
    private void UpdateCenterline() {
        this.centerline = ParametricLine(this.dir, this.origin);
    }

    // Check if vector is in volume
    bool IsInVolume(Vector v) {
        
        // If we're further from the line than radius, we aren't in volume
        if (this.centerline.GetDistance(v) > this.radius) {
            return false;
        }


        // We also have to check for the end caps.

        // Since direction vectors get normalized, we can calculate the start point of the cylinder by inputting length
        // as length of (centerline.pointat(this.length/2) - origin) will be equal to length / 2, which is what we need

        Vector ort_proj = this.centerline.OrthogonalProjection(v);
        double t;
        this.centerline.GetParameterForPoint(ort_proj, t); // We know the point belongs to the line since it's an orthogonal projection
        
        return t >= -this.length/2 && t <= this.length/2;

    }
}