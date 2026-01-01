// --------------------------------
// Purpose: Test the parametric line class in math.as
// --------------------------------


#include "../misc/math.as"
#include "../misc/logger.as"

[ServerCommand("as_pline_test", "")]
void test_parametricline(const CommandArgs@ args) {
    Logger logger("PLine_logger");

    ParametricLine pline1(Vector(1, 2, -1), Vector(1, -3, 5));
    ParametricLine pline2(Vector(2, 1, -1), Vector(6, 1, 2));

    Vector intersection;

    bool did_intersect = pline1.LineIntersection(pline2, intersection);

    //Intersection should occur at (2, -1, 4)
    logger.Info("Intersection did occur: " + did_intersect);
    logger.Info("Intersection coordinates: " + intersection[0] + " " + intersection[1] + " " + intersection[2]);


    logger.Info("Checking if point (3, 1, 3) belongs to pline1 (it does): " + pline1.PointBelongsToLine(Vector(3, 1, 3)));
    logger.Info("Checking if point (3, 0, 3) belongs to pline1 (it doesn't): " + pline1.PointBelongsToLine(Vector(3, 0, 3)));

    Vector projection = pline1.OrthogonalProjection(Vector(10, 10, 10));
    logger.Info("Performing orthogonal projection of point (10, 10, 10) onto pline1 (expected result is 6, 7, 0): (" + projection[0] + ", " + projection[1] + ", " + projection[2] + ")");
    
    double t;
    bool point_exists = pline1.GetParameterForPoint(projection, t);
    logger.Info(" For the point up above, t = " + t);

}