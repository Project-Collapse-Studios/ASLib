// --------------------------------
// Purpose: 
// --------------------------------

#include "../../types/volumes/VolumeInterface.as"

[Entity("trigger_as")]
class TriggerAS : CBaseEntity {
    
    array<VolumeInterface@> Volumes;

    // TODO: Re-implement when GetBoundingBox gets exposed.
    Vector BMaxs, BMins;

    void Spawn() {
        SetSolid( SOLID_BBOX );
        //SetCollisionBounds(Vector(-8, -8, -8), Vector(8, 8, 8));
        ThinkFunc_t@ thinkfunc = ThinkFunc_t(this.ThinkRotate);
        this.SetThink(thinkfunc, 0.03);
    }

    // Add a new volume
    void AddVolume(VolumeInterface@ volume, bool absolute_origin = false) {
        
        // Recalculate bounding box
        Vector vol_maxs = volume.GetAABBMax() + volume.GetOrigin();
        Vector vol_mins = volume.GetAABBMin() + volume.GetOrigin();
        if (this.Volumes.length() == 0) { // We're setting BBOX for the first time
            this.BMaxs = vol_maxs; // We cannot expect AABB max/mins to be strictly positive/negative by component
            this.BMins = vol_mins;
        }/* else {
            this.BMaxs = this.GetBoundingMaxs();
            this.BMins = this.GetBoundingMins();
            }*/
        if (vol_maxs.x > this.BMaxs.x) {this.BMaxs.x = vol_maxs.x;}
        if (vol_maxs.y > this.BMaxs.y) {this.BMaxs.y = vol_maxs.y;}
        if (vol_maxs.z > this.BMaxs.z) {this.BMaxs.z = vol_maxs.z;}
        if (vol_mins.x < this.BMins.x) {this.BMins.x = vol_mins.x;}
        if (vol_mins.y < this.BMins.y) {this.BMins.y = vol_mins.y;}
        if (vol_mins.z < this.BMins.z) {this.BMins.z = vol_mins.z;}
        
        
        Msgl("Setting bounds: MAX: " + this.BMaxs.x + ", " + this.BMaxs.y + ", " + this.BMaxs.z );
        Msgl("Setting bounds: MIN: " + this.BMins.x + ", " + this.BMins.y + ", " + this.BMins.z );
        this.SetCollisionBounds(this.BMins, this.BMaxs);
        this.Volumes.insertLast(volume);
    }

    protected void ThinkRotate() {
        this.SetNextThink(0.03);
    }
}