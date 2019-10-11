---
layout: page
title: DDSS Alloys
---

Many alloys can be created in DDSS, and recipes vary whether you have Alloy Smelters, or use the Smeltery or not.  All recipes here are scaled to use full units (ingots/dusts/blocks etc), and not leaving behind any partial remnants.  Any component in orange is a component that is causing the whole recipe to be multiplied out to find a common factor and you should consider storing that in liquid form.

# Alumite

| Property | Notes |
| --- | --- |
| Mining Level | Cobalt |
| Head Trait | Global Traveller - Mined materials teleport to a chest |

## Production (Smeltery)

<div class="mermaid">
  graph TD;
  BasaltBlock[6 Basalt Block] --> Basalt;
  BasaltBlock -->|Extra| BasaltSpare[6 Basalt Ingot]
  TiberiumOre[30 Tiberium Ore] --> Tiberium;
  ManasteelBlock[1 Manasteel Block] --> Manasteel;
  SilverOre[2 Silver Ore] --> Silver;
  SilverOre -->|Extra| SilverSpare[1 Silver Ingot];
  Basalt[48 Basalt Ingot] --> Triberium;
  Tiberium[60 Tiberium Ingot] --> Triberium;
  Manasteel[9 Manasteel Ingot] --> Shibuichi;
  Silver[3 Silver Ingot] --> Shibuichi;
  Triberium[8 Triberium Ingot] --> Aluminum;
  Shibuichi[4 Shibuichi Ingot] --> Aluminum;
  Aluminum[20 Aluminum Ingot] --> Alumite;
  Iron[8 Iron Ingot] --> Alumite;
  Obsidian[4 Obsidian Block] --> Alumite;
  Alumite[4 Alumite Ingot];
  style Manasteel stroke:#f66,stroke-width:2px
  style Silver stroke:#f66,stroke-width:2px
</div>

# Manyullyn

<div class="mermaid">
  graph TD;
  Cobalt[1 Cobalt Ingot] --> Manyullyn;
  Ardite[1 Ardite Ingot] --> Manyullyn;
  Manyullyn[1 Manyullyn Ingot];
</div>

# Bronze

<div class="mermaid">
  graph TD;
  Copper[3 Copper Ingot] --> Bronze;
  Tin[1 Tin Ingot] --> Bronze;
  Bronze[4 Bronze Ingot];
</div>

# Terrax

<div class="mermaid">
  graph TD;
  VanadiumOre[1 Vanadium Ore] --> VanadiumDust;
  GalenaOre[2 Galena Ore] --> GalenaDust;
  VanadiumDust[2 Vanadium Dust] --> Ovium;
  GalenaDust[4 Galena Dust] --> Ovium;
  Ovium[2 Ovium Ingot] --> Terrax;
  KarmesineOre[1 Karmesine Ore] --> Karmesine;
  JauxumOre[1 Jauxum Ore] --> Jauxum;
  Karmesine[2 Karmesine Ingot] --> Terrax;
  Jauxum[2 Jauxum Ingot] --> Terrax;
  Terrax[4 Terrax Ingot]; 
</div>
