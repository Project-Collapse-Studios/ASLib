// --------------------------------
// Purpose: Test the cuboid volume simple object.
// --------------------------------

#include "../types/volumes/CuboidVolumeSimple.as"
#include "../misc/logger.as"

#include "../types/volumes/CuboidVolume.as"

#include "../entities/server/trigger_as.as"
#include "../types/volumes/CylindricalVolume.as"




[ServerCommand("as_test_cuboidsimple", "")]
void TestCuboidSimple(const CommandArgs@ args) {
    
    Logger logger("Test-CuboidSimpleVolume");
/*
    CuboidVolumeSimple vol(Vector(-10, -10, -10), Vector(10, 10, 10)); // At map origin


    // Testing IsInVolume

    Vector tst_vector = Vector(5, 5, 5);

    logger.Info("Test vector 5, 5, 5 belongs in volume, expected True: " + vol.IsInVolume(tst_vector));

    vol.Scale(.5);

    logger.Info("Volume scaled by 1/2: (XYZ) " + vol.GetLenX() + " " + vol.GetLenY() + " " + vol.GetLenZ());
    logger.Info("Scaling volume by 1/2, testing edge, expected True: " + vol.IsInVolume(tst_vector) + "\n");

    vol.Scale(.5);
    logger.Info("Volume scaled by 1/2: (XYZ) " + vol.GetLenX() + " " + vol.GetLenY() + " " + vol.GetLenZ());
    logger.Info("Scaling by 1/2 again, expected False: " + vol.IsInVolume(tst_vector) + "\n");

    logger.Info("Setting origin to 10 10 10, scaling by 2");
    
    vol.SetOrigin(Vector(20, 20, 20));
    vol.Scale(2);

    logger.Info("Test vector 5 5 5 belongs? Expected False: " + vol.IsInVolume(tst_vector));
*/


    //CuboidVolume vol2(Vector(-64, -64, -64), Vector(64, 64, 64), Vector(0, 0, 192), QAngle(17, 65, 0));
    //logger.Info("Visualizing vol2 at 0, 0, 192!");
    //vol2.Visualize();
    CylindricalVolume vol2(32, 128, Vector(-1, 1, 1), Vector(0, 0, 64));


    auto@ a = util::CreateEntityByNameT<TriggerAS>("trigger_as");
    a.AddVolume(@vol2);
    a.Spawn();
}