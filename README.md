# Codigo fuente del juego "Nacida del metal"

---

## Estructura del proyecto

├── icon.svg \
├── icon.svg.import \
├── project.godot \
├── README.md \
├── resources - Aqui todo recurso que cambie el aspecto de algo (sonidos?) \
│   └── temas-de-botones-o-fuentes.txt \
├── scenes \
│   ├── characters - Cualquier personaje, friend or foe \
│   │   ├── nacida.gd \
│   │   ├── nacida.gd.uid \
│   │   └── nacida.tscn \
│   └── levels - Aqui los niveles \
│       └── level_1.tscn \
└── textures - :v \
    └── characters \
        └── img-y-texturas.txt \

### Autoloads

Debug.gd -> nos permite mostrar las acciones en pantalla se usa de la siguient forma:

```python
Debug.log(...)
```

Game.gd -> en este script, la nacida se genera globalmente, y asi los metales pueden
interactuar con ella.
