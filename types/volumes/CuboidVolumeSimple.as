// --------------------------------
// Purpose: Object representing a simple (axis alligned) cuboid volume in world.
// --------------------------------

#include "VolumeInterface.as"

#if DEBUG
#include "../../misc/string.as"
#endif


// Implements an axis alligned cuboid volume in world.
class CuboidVolumeSimple : VolumeInterface {

    protected double len_x, len_y, len_z;
    
    protected Vector origin;

#if DEBUG
    protected array<CBaseEntity@> visualizers;
#endif

    // === CONSTRUCTORS ===

    // Initialize mixin functionality from Min, Max vectors, optional origin vector = [0, 0, 0] is used to orient this volume in space.
    CuboidVolumeSimple(Vector Min, Vector Max, Vector origin = Vector(0, 0, 0)) {
        this.len_x = abs(Max[0] - Min[0]);
        this.len_y = abs(Max[1] - Min[1]);
        this.len_z = abs(Max[2] - Min[2]);

        this.origin = origin;

#if DEBUG
        this.LoadVisualizers();
#endif
    }

    // Initialize mixin functionality from dimensions x, y ,z, optional origin vector = [0, 0, 0] is used to orient this volume in space.
    CuboidVolumeSimple(double length_x, double length_y, double length_z, Vector origin = Vector(0, 0, 0)) {
        this.len_x = length_x;
        this.len_y = length_y;
        this.len_z = length_z;
        this.origin = origin;

#if DEBUG
        this.LoadVisualizers();
#endif
    }

    // === END ===

    // Set the length in the X axis.
    void SetLengthX(double len) {
        this.len_x = len;
    }

    // Set the length in the Y axis.
    void SetLengthY(double len) {
        this.len_y = len;
    }

    // Set the length in the Z axis.
    void SetLengthZ(double len) {
        this.len_z = len;
    }

    // Scale the whole object by this value.
    void Scale(double s) {
        this.len_x *= s;
        this.len_y *= s;
        this.len_z *= s;
    }

    // Scale length in the X axis by this value.
    void ScaleX(double s) {
        this.len_x *= s;
    }

    // Scale length in the Y axis by this value.
    void ScaleY(double s) {
        this.len_y *= s;
    }

    // Scale length in the Z axis by this value.
    void ScaleZ(double s) {
        this.len_z *= s;
    }

    // Get this volumes origin.
    Vector GetOrigin() {
        return this.origin;
    }

    // Set this volume's origin.
    void SetOrigin(Vector origin) {
        this.origin = origin;
    }

    double GetLenX() {
        return this.len_x;
    }

    double GetLenY() {
        return this.len_y;
    }

    double GetLenZ() {
        return this.len_z;
    }

    // Get the Max vector of AABB
    Vector GetAABBMax() {
        return Vector(this.len_x/2, this.len_y/2, this.len_z/2);
    }

    // Get the Min vector of AABB
    Vector GetAABBMin() {
        return -this.GetAABBMax();
    }

    // Checks if this vector is inside of this volume
    bool IsInVolume(Vector v) {
        v -= this.origin; // In our local space

        return ( // Edges also belong to the volume
            v[0] >= -this.len_x/2 && v[0] <= this.len_x/2 &&
            v[1] >= -this.len_y/2 && v[1] <= this.len_y/2 &&
            v[2] >= -this.len_z/2 && v[2] <= this.len_z/2
        );
    }

    // Get the scalar of this volume in u^3
    double GetVolume() {
        return this.len_x * this.len_y * this.len_z;
    }

#if DEBUG
    void LoadVisualizers() {
        CBaseEntity@ ent = null;
        string basename =  "";
        for (int i = 1; i < 8; i++) {
            basename = "ASVOLUMES_DEBUGLASER_" + str::GetUnique() + "_";
            @ent = util::CreateEntityByName("env_laser"); // CBaseEntity interface will be sufficient here

            ent.KeyValue("targetname", basename + i);
            ent.KeyValue("rendercolor", "250 165 88");
            ent.KeyValue("texture", "sprites/laserbeam.spr");
            ent.KeyValue("spawnflags", 1);
            ent.KeyValue("renderamt", "200");
            ent.KeyValue("lasertarget", basename + (i+1));
            ent.KeyValue("hdrcolorscale", "1");
            ent.KeyValue("rendermode", "1");
            ent.KeyValue("texturescroll", "35");
            ent.KeyValue("width", "2");

            this.visualizers.insertLast(ent);
        }

        @ent = util::CreateEntityByName("info_target");
        ent.KeyValue("targetname", basename + "9");
        ent.KeyValue("spawnflags", 2);
        ent.Spawn();
        this.visualizers.insertLast(ent);

        for (int i = 0; i < 7; i++) {
            auto@ ent_ = this.visualizers[6 - i];
            ent_.Spawn();
        }
    }


    void Visualize() {
        if (this.visualizers.length() < 8) {
            return;
        }
        
        // Bottom plane
        Vector v0 = Vector(-this.len_x / 2, -this.len_y/2, -this.len_z/2);
        Vector v1 = Vector(this.len_x / 2, -this.len_y/2, -this.len_z/2);
        Vector v2 = Vector(this.len_x / 2, this.len_y/2, -this.len_z/2);
        Vector v3 = Vector(-this.len_x / 2, this.len_y/2, -this.len_z/2);

        // Upper plane
        Vector v4 = -v2;
        Vector v5 = -v3;
        Vector v6 = -v0;
        Vector v7 = -v1;
        
        Msg("Vectors done!");

        //auto@ ent = this.visualizers[0];
        //if (@ent == null) {
        //    Msg("Ent is null!");
        //    throw("Ent is null!");
        //}
        //this.visualizers[0].SetAbsOrigin(v0 + this.origin);
        //this.visualizers[1].SetAbsOrigin(v1 + this.origin);
        //this.visualizers[2].SetAbsOrigin(v2 + this.origin);
        //this.visualizers[3].SetAbsOrigin(v3 + this.origin);
        //this.visualizers[4].SetAbsOrigin(v4 + this.origin);
        //this.visualizers[5].SetAbsOrigin(v5 + this.origin);
        //this.visualizers[6].SetAbsOrigin(v6 + this.origin);
        //this.visualizers[7].SetAbsOrigin(v7 + this.origin);
        EntityList().FindByName(null,"DEBUG_LASER_1").SetAbsOrigin(v0 + this.origin);
        EntityList().FindByName(null,"DEBUG_LASER_2").SetAbsOrigin(v1 + this.origin);
        EntityList().FindByName(null,"DEBUG_LASER_3").SetAbsOrigin(v2 + this.origin);
        EntityList().FindByName(null,"DEBUG_LASER_4").SetAbsOrigin(v3 + this.origin);
        EntityList().FindByName(null,"DEBUG_LASER_5").SetAbsOrigin(v4 + this.origin);
        EntityList().FindByName(null,"DEBUG_LASER_6").SetAbsOrigin(v5 + this.origin);
        EntityList().FindByName(null,"DEBUG_LASER_7").SetAbsOrigin(v6 + this.origin);
        EntityList().FindByName(null,"DEBUG_LASER_8").SetAbsOrigin(v7 + this.origin);
    }
#endif

}