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