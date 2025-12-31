// --------------------------------
// Purpose: Test the cuboid volume simple object.
// --------------------------------

#include "../mixins/volumes/CuboidVolumeSimple.as"

[ServerCommand("as_test_cuboidsimple", "")]
void TestCuboidSimple(const CommandArgs@ args) {
    CuboidVolumeSimple vol(Vector(-10, -10, -10), Vector(10, 10, 10)); // At map origin


    // Testing IsInVolume

    Vector tst_vector = Vector(5, 5, 5);

    Msg("Test vector 5, 5, 5 belongs in volume, expected True: " + vol.IsInVolume(tst_vector) + "\n");

    vol.Scale(.5);

    Msg("Volume scaled by 1/2: (XYZ) " + vol.GetLenX() + " " + vol.GetLenY() + " " + vol.GetLenZ());
    Msg("Scaling volume by 1/2, testing edge, expected True: " + vol.IsInVolume(tst_vector) + "\n");

    vol.Scale(.5);
    Msg("Volume scaled by 1/2: (XYZ) " + vol.GetLenX() + " " + vol.GetLenY() + " " + vol.GetLenZ());
    Msg("Scaling by 1/2 again, expected False: " + vol.IsInVolume(tst_vector) + "\n");
}