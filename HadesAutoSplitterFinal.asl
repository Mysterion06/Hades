state("Hades") {
    string10 timeDisplay : "EngineWin64s.dll", 0x006AC5C0, 0xD8, 0x10, 0x78, 0x78, 0x8, 0x588, 0xC70, 0x18;
    int roomID: "EngineWin64s.dll", 0x68ED74;
}

startup {
    vars.timeBeforeEmpty = "";
}

init
{
    vars.split = 0;
}

update {
    if (String.IsNullOrEmpty(current.timeDisplay) && !String.IsNullOrEmpty(old.timeDisplay)) vars.timeBeforeEmpty = old.timeDisplay;
    vars.timeSplit = String.IsNullOrEmpty(current.timeDisplay) ? vars.timeBeforeEmpty.Split(':', '.') : current.timeDisplay.Split(':', '.');
}

start {
    try {
        current.totalSeconds =
        Convert.ToSingle(vars.timeSplit[0]) * 60 +
        Convert.ToSingle(vars.timeSplit[1]) +
        Convert.ToSingle(vars.timeSplit[2]) / 100;

        return old.totalSeconds > current.totalSeconds;
    } catch {}
}

split
{
    if(((old.roomID == 10 || old.roomID == 8 || old.roomID == 11) && current.roomID == 27 && vars.split == 0) // Tartarus
    ||
    (current.roomID == 11 && old.roomID == 28 && vars.split == 1) // Asphodel
    ||
    (current.roomID == 28 && old.roomID == 25 && vars.split == 2) // Elysium
    ||
    (current.roomID == 11 && old.roomID == 13 && vars.split == 3)){ // Pupper
        vars.split++;
        return true;
    }
}

reset
{
    if(current.roomID == 21 && old.roomID == 11){
        vars.split = 0;
        return true;
    }
}

isLoading {
    return true;
}

gameTime {
    try {
        int h = Convert.ToInt32(vars.timeSplit[0]) / 60;
        int m = Convert.ToInt32(vars.timeSplit[0]) % 60;
        int s = Convert.ToInt32(vars.timeSplit[1]);
        int ms = Convert.ToInt32(vars.timeSplit[2] + "0");

        return new TimeSpan(0, h, m, s, ms);
    } catch {}
}
