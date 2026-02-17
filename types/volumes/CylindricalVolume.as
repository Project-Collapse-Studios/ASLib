// --------------------------------
// Purpose: Object representing a cylindrical volume in world.
// --------------------------------

#include "VolumeInterface.as"
#include "../../math/ParametricLine.as"
#include "../../math/basic_functions.as"
#include "../../math/constants.as"

class CylindricalVolume : VolumeInterface {

    protected double radius, length;
    protected Vector dir;
    protected Vector origin;
    protected matrix3x4_t RotationMatrix;

    // Line that represents the center of the cylinder and it's direction
    protected ParametricLine@ centerline;

    // === CONSTRUCTORS ===

    // Initialize from radius, length and direction vector. Optional origin vector used to orient this volume in space.
    CylindricalVolume(double radius, double length, Vector dir_vec, Vector origin = Vector(0, 0, 0)) {
        this.radius = radius;
        this.length = length;
        this.dir = dir_vec.Normalized();
        this.origin = origin;

        // In our basis, we're based on the Up vector (0, 0, 1). In the canonical basis that vector is this.dir
        MatrixBuildRotationAboutAxis(this.dir.Cross(Vector(0, 0, 1)), acos(this.dir.z) * 360/(2 * PI), this.RotationMatrix);
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
        MatrixBuildRotationAboutAxis(this.dir.Cross(Vector(0, 0, 1)), acos(this.dir.z), this.RotationMatrix);
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
        @this.centerline = @ParametricLine(this.dir, this.origin);
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

    double GetVolume() {
        return this.radius * this.radius * PI * this.length;
    }

    Vector GetAABBMax() {
        // We can approximate by making a OOBB
        Vector v0 = Vector(this.radius, this.radius, -this.length/2);
        Vector v1 = Vector(this.radius, this.radius, this.length/2); // These are described in our local basis
        Vector v2 = Vector(-this.radius, this.radius, this.length/2);
        Vector v3 = Vector(this.radius, -this.radius, this.length/2);

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

    Vector GetAABBMin() {
        return -GetAABBMax();
    }

    // Check if vector is in volume
    bool IsInVolume(Vector v) {
        
        // If we're further from the line than radius, we aren't in volume
        if (this.centerline.GetDistance(v) > this.radius) {
            return false;
        }


        // We also have to check for the end caps.

        // Since direction vectors get normalized, we can calculate the start point of the cylinder by inputting length,
        // as length of (centerline.pointat(this.length/2) - origin) will be equal to length / 2, which is what we need

        Vector ort_proj = this.centerline.OrthogonalProjection(v);
        double t;
        this.centerline.GetParameterForPoint(ort_proj, t); // We know the point belongs to the line since it's an orthogonal projection
        
        return t >= -this.length/2 && t <= this.length/2;

    }
}