// --------------------------------
// Purpose: Provide convienience functions/objects that aid with math.
// --------------------------------

const double epsilon_ = 0.0005;

/* Represents a 3D parametric line in space.
x = vx * t + point_x
y = vy * t + point_y, t belongs to Real
z = vz * t + point_z

This object acts as immutable, if you want a different line, you need to create a new object for it.
*/
class ParametricLine {
    protected double vx, vy, vz;
    protected Vector point;

    // Create a line from a vector pointing a direction and a point that belongs to this line.
    ParametricLine(const Vector&in dir, const Vector point) {
        this.vx = dir[0];
        this.vy = dir[1];
        this.vz = dir[2];

        this.point = point;
    }

    // Create a line from raw dir vector components, for double precision, and a point that belongs to this line.
    ParametricLine(const double vx, const double vy, const double vz, const Vector point) {
        this.vx = vx;
        this.vy = vy;
        this.vz = vz;
        this.point = point;
    }

    double GetVX() const {
        return this.vx;
    }

    double GetVY() const {
        return this.vy;
    } 

    double GetVZ() const {
        return this.vz;
    }

    // Returns if this point belong to the line (or is extremely close). Pass epsilon to set the accuracy, default is 0.00005
    bool PointBelongsToLine(const Vector&in point, const double epsilon = epsilon_) const {
        // We just need to check if we can get a t.
        double _;
        return this.GetParameterForPoint(point, _, epsilon);
    }

    // Get a point at specific t
    Vector GetPointAtT(const double t) const {
        return Vector(this.vx * t, this.vy * t, this.vz * t) + point;
    }

    // Get the parameter value for this point, if this point belongs to this line.
    bool GetParameterForPoint(const Vector&in point, double&out t_out, const double epsilon = epsilon_) const {

        double t = (point[0] - this.point[0]) / this.vx;

        if (
            abs(point[1] - this.vy * t - this.point[1]) < epsilon &&
            abs(point[2] - this.vz * t - this.point[2]) < epsilon
        ) {
            t_out = t;
            return true;
        } else {
            return false;
        }
    }

    // Calculate the intersection point (if exists) of two parametric lines.
    // Vector parameter is the result (&out), function returns bool to indicate if the intersection exists.
    bool LineIntersection(const ParametricLine&in line, Vector&out intersection, const double epsilon = 0.0005) const {
        /* We're solving
            v1x * t + p1x = v2x * s + p2x
            v1y * t + p1y = v2y * s + p2y
            v1z * t + p1z = v2z * s + p2z

            We know: v1, v2, p1, p2. We can calculate t and s and check if the last condition is true.

            t = (v2x * s + p2x - p1x) / v1x
            s = (v1y(v2x * s + p2x - p1x) / v1x + p1y - p2y) / v2y
        */
        double mi = this.vx / this.vy;
        Vector tp = line.GetPointAtT(0); // Their point; doesn't really matter which one we get, but 0 gives us the original one

        double s = mi * (tp[1] - this.point[1]) + this.point[0];
        s /= (line.GetVY() * mi) - line.GetVX();

        double t = (line.GetVX() * s + tp[0] - this.point[0] ) / this.vx;
        
        if (abs(this.vz * t + this.point[2] - line.GetVZ() * s - tp[2]) < epsilon) {
            intersection = ( this.GetPointAtT(t) + line.GetPointAtT(s) ) / 2; //This will give us the best approximation in case we are not "perfectly" intersecting (but are very close)
            return true;
        } else {
            return false;
        }
    }

    // Perform an orthogonal projection onto this line
    Vector OrthogonalProjection(const Vector&in point) const {
        if (this.PointBelongsToLine(point)) { // If the point belongs to the line, it is it's own projection of itself
            return point;
        }

        // P' (orthogonal projection of P) = [a, b, c]
        // Vec(PP') = [a - px, b - py, c - pz]
        // Vec(PP') dot [vx, vy, vz] == 0, these vectors must be perpendicular
        // We get: vx(a-px) + vy(b-py) + vz(c-pz) = 0

        // Additionally, P' must belong to us p0 = this.point
        // our final equation is, we want to get t
        // vx(vx * t + p0x - px) + vy(vy * t + p0y - py) + vz(vz * t + p0z - pz) = 0 
        // t(vx^2 + vy^2 + vz^2) = vx(px - p0x) + vy(py - p0y) + vz(pz  - p0z)
        
        double t = ( this.vx * (point[0] - this.point[0]) + this.vy * (point[1] - this.point[1]) + this.vz * (point[2] - this.point[2]) ) / (this.vx * this.vx + this.vy * this.vy + this.vz * this.vz);

        return GetPointAtT(t);
    }

    // Calculate the distance from this point to this parametric line.
    double GetDistance(const Vector&in point) const {
        return this.point.Cross(point - this.point).Length() / point.Length();
    }
}