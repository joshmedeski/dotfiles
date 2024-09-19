const fontStyles = [
  {
    "name": "Default",
    "id": "default",
    "type": "clockdigits",
    "preset": {
        "dial": {
            "useCountdown": true
        }
    }
  },
  {
    "name": "Aldrich",
    "file": "aldrich.svg",
    "id": "aldrich",
    "type": "clockdigits",
    "preset": {
      "scale": {
        "default": 0.7,
        "withSeconds": 0.5,
        "Keypad": {
          "default": 0.7,
          "withSeconds": 0.45
        }
      },
      "topOffset": {
        "default": 12.5,
        "withSeconds": 27.5,
        "Keypad": {
          "default": 28,
          "withSeconds": 52
        }
      },
      "leftOffset": {
        "default": 25,
        "withSeconds": 30,
        "Keypad": {
          "default": 2,
          "withSeconds": 4
        }
      }
    }
  },
  {
    "name": "Blauman",
    "file": "baumans.svg",
    "id": "bauman",
    "type": "clockdigits",
    "preset": {
      "hours": {
        "color": "#0099ee",
        "$hideLayer": false
      },
      "minutes": {
        "color": "#0099ee",
        "$hideLayer": false
      },
      "seconds": {
        "color": "#0099ee",
        "$hideLayer": true
      },
      "colons": {
        "color": "#0077cc"
      },
      "date": {
        "color": "#D593E3",
        "fontSize": 9,
        "$hideLayer": true
      },
      "scale": {
        "default": 0.7,
        "withSeconds": 0.5,
        "Keypad": {
          "default": 0.54,
          "withSeconds": 0.38
        }
      },
      "topOffset": {
        "default": 20,
        "withSeconds": 34,
        "Keypad": {
          "default": 52,
          "withSeconds": 80
        }
      },
      "leftOffset": {
        "default": 14,
        "withSeconds": 12,
        "Keypad": {
          "default": 8,
          "withSeconds": 2
        }
      }
    }
  },
  {
    "name": "Bahiana",
    "file": "bahianaregular.svg",
    "id": "bahiana",
    "type": "clockdigits",
    "preset": {
      "hours": {
        "color": "#FF6600",
        "$hideLayer": false
      },
      "minutes": {
        "color": "#FF6600",
        "$hideLayer": false
      },
      "seconds": {
        "color": "#FF6600",
        "$hideLayer": true
      },
      "date": {
        "color": "#FF6600",
        "fontSize": 9,
        "$hideLayer": true
      },
      "colons": {
        "color": "#FF6600",
      },
      "scale": {
        "default": 0.6,
        "withSeconds": 0.56,
        "Keypad": {
          "default": 0.7,
          "withSeconds": 0.44
        }
      },
      "topOffset": {
        "default": 22,
        "withSeconds": 24,
        "Keypad": {
          "default": 30,
          "withSeconds": 62
        }
      },
      "leftOffset": {
        "default": 32,
        "withSeconds": 16,
        "Keypad": {
          "default": 2,
          "withSeconds": 6
        }
      }
    }
  },
  {
    "name": "Balls",
    "id": "balls",
    "file": "balls",
    "type": "clockdigits"
  },
  {
    "name": "Blocks",
    "id": "blocks",
    "file": "blocks",
    "type": "clockdigits"
  },
  {
    "name": "Bayon",
    "file": "bayon.svg",
    "id": "bayon",
    "type": "clockdigits",
    "preset": {
      "scale": {
        "default": 1,
        "withSeconds": 0.65,
        "Keypad": {
          "default": 0.7,
          "withSeconds": 0.45
        }
      },
      "topOffset": {
        "default": 0,
        "withSeconds": 15,
        "Keypad": {
          "default": 28,
          "withSeconds": 52
        }
      },
      "leftOffset": {
        "default": 0,
        "withSeconds": 0,
        "Keypad": {
          "default": 0,
          "withSeconds": 0
        }
      }
    }
  },
  {
    "name": "Edgy",
    "file": "edgy.svg",
    "id": "edgy",
    "type": "clockdigits",
    "preset": {
      "scale": {
        "default": 0.7,
        "withSeconds": 0.52,
        "Keypad": {
          "default": 0.6,
          "withSeconds": 0.46
        }
      },
      "topOffset": {
        "default": 20,
        "withSeconds": 32,
        "Keypad": {
          "default": 48,
          "withSeconds": 64
        }
      },
      "leftOffset": {
        "default": 25,
        "withSeconds": 20,
        "Keypad": {
          "default": 12,
          "withSeconds": 2
        }
      }
    }
  },
  {
    "name": "GeostarFill",
    "file": "geostarfill.svg",
    "id": "geostarfill",
    "type": "clockdigits",
    "preset": {
      "hours": {
        "color": "#4A90E2",
        "$hideLayer": false
      },
      "minutes": {
        "color": "#4A90E2",
        "$hideLayer": false
      },
      "seconds": {
        "color": "#4A90E2",
        "$hideLayer": true
      },
      "date": {
        "color": "#2A70C2",
        "fontSize": 7,
        "long": true,
        "$hideLayer": true
      },
      "scale": {
        "default": 0.7,
        "withSeconds": 0.5,
        "Keypad": {
          "default": 0.48,
          "withSeconds": 0.36
        }
      },
      "topOffset": {
        "default": 22,
        "withSeconds": 32,
        "Keypad": {
          "default": 58,
          "withSeconds": 84
        }
      },
      "leftOffset": {
        "default": 12,
        "withSeconds": 4,
        "Keypad": {
          "default": 16,
          "withSeconds": 6
        }
      }
    }
  },
  {
    "name": "IndieFlower",
    "file": "indieflower.svg",
    "id": "indieflower",
    "type": "clockdigits",
    "preset": {
      "hours": {
        "color": "#FFAA00",
        "$hideLayer": false
      },
      "minutes": {
        "color": "#FFAA00",
        "$hideLayer": false
      },
      "seconds": {
        "color": "#FFAA00",
        "$hideLayer": true
      },
      "colons": {
        "color": "#FFAA00",
        "$hideLayer": false
      },
      "date": {
        "color": "#FFBB00",
        "fontSize": 7,
        "long": false,
        "$hideLayer": true
      },
      "scale": {
        "default": 0.7,
        "withSeconds": 0.52,
        "Keypad": {
          "default": 0.6,
          "withSeconds": 0.42
        }
      },
      "topOffset": {
        "default": 16,
        "withSeconds": 28,
        "Keypad": {
          "default": 42,
          "withSeconds": 68
        }
      },
      "leftOffset": {
        "default": 20,
        "withSeconds": 16,
        "Keypad": {
          "default": 8,
          "withSeconds": 2
        }
      }
    }
  },
  {
    "name": "IngridDarling",
    "file": "ingriddarling.svg",
    "id": "ingriddarling",
    "type": "clockdigits",
    "preset": {
      "grid": {
        "color": "#0000FF",
        "topOffset": 5,
        "gridSize": 8,
        "lineWidth": 1,
        "$hideLayer": false
      },
      "hours": {
        "color": "#FFCC00",
        "$hideLayer": false
      },
      "minutes": {
        "color": "#BD10E0",
        "$hideLayer": false
      },
      "seconds": {
        "color": "#BD10E0",
        "$hideLayer": true
      },
      "colons": {
        "color": "#FFAA00",
        "$hideLayer": false
      },
      "date": {
        "color": "#D593E3",
        "fontSize": 9,
        "$hideLayer": true
      },
      "scale": {
        "default": 0.7,
        "withSeconds": 0.52,
        "Keypad": {
          "default": 0.5,
          "withSeconds": 0.36
        }
      },
      "topOffset": {
        "default": 18,
        "withSeconds": 30,
        "Keypad": {
          "default": 54,
          "withSeconds": 80
        }
      },
      "leftOffset": {
        "default": 20,
        "withSeconds": 16,
        "Keypad": {
          "default": 12,
          "withSeconds": 0
        }
      }
    }
  },
  {
    "name": "LED",
    "file": "led.svg",
    "id": "led",
    "type": "clockdigits",
    "preset": {
      "grid": {
        "color": "#000C00",
        "$hideLayer": false
      },
      "hours": {
        "color": "#00CC00",
        "$hideLayer": false
      },
      "minutes": {
        "color": "#00CC00",
        "$hideLayer": false
      },
      "seconds": {
        "color": "#00CC00",
        "$hideLayer": true
      },
      "scale": {
        "default": 0.25,
        "withSeconds": 0.25,
        "Keypad": {
          "default": 0.2,
          "withSeconds": 0.175
        }
      },
      "topOffset": {
        "default": 54,
        "withSeconds": 54,
        "Keypad": {
          "default": 132,
          "withSeconds": 154
        }
      },
      "leftOffset": {
        "default": 58,
        "withSeconds": 4,
        "Keypad": {
          "default": 36,
          "withSeconds": 0
        }
      }
    }
  },
  {
    "name": "Londrina",
    "file": "londrinaoutline.svg",
    "id": "londrinaoutline",
    "type": "clockdigits",
    "preset": {
      "hours": {
        "color": "#6666FF",
        "$hideLayer": false
      },
      "minutes": {
        "color": "#6666FF",
        "$hideLayer": false
      },
      "seconds": {
        "color": "#6666FF",
        "$hideLayer": true
      },
      "colons": {
        "color": "#4444ee"
      },
      "date": {
        "color": "#6666FF",
        "fontSize": 11,
        "$hideLayer": true
      },
      "translatex": {
        "default": [
          0,
          4,
          27,
          49,
          70,
          93,
          114,
          136,
          159
        ]
      },
      "scale": {
        "default": 0.7,
        "withSeconds": 0.5,
        "Keypad": {
          "default": 0.56,
          "withSeconds": 0.36
        }
      },
      "topOffset": {
        "default": 14,
        "withSeconds": 28,
        "Keypad": {
          "default": 44,
          "withSeconds": 80
        }
      },
      "leftOffset": {
        "default": 10,
        "withSeconds": 4,
        "Keypad": {
          "default": 1,
          "withSeconds": 2
        }
      }
    }
  },
  {
    "name": "Monoton",
    "file": "monoton.svg",
    "id": "monoton",
    "type": "clockdigits",
    "preset": {
      "hours": {
        "color": "#4A90E2",
        "$hideLayer": false
      },
      "minutes": {
        "color": "#4A90E2",
        "$hideLayer": false
      },
      "seconds": {
        "color": "#4A90E2",
        "$hideLayer": true
      },
      "date": {
        "color": "#2A70C2",
        "fontSize": 7,
        "long": true,
        "$hideLayer": true
      },
      "scale": {
        "default": 0.7,
        "withSeconds": 0.5,
        "Keypad": {
          "default": 0.48,
          "withSeconds": 0.36
        }
      },
      "topOffset": {
        "default": 18,
        "withSeconds": 28,
        "Keypad": {
          "default": 52,
          "withSeconds": 80
        }
      },
      "leftOffset": {
        "default": 8,
        "withSeconds": 0,
        "Keypad": {
          "default": 8,
          "withSeconds": 2
        }
      }
    }
  },
  {
    "name": "XL Belgium",
    "id": "belgium",
    "file": "belgium.svg",
    "type": "clockdigits",
    "preset": {
      "hours": {
        "color": "#FF0097",
        "$hideLayer": false
      },
      "minutes": {
        "color": "#FF0097",
        "$hideLayer": false
      },
      "seconds": {
        "color": "#FF0097",
        "$hideLayer": true
      },
      "colons": {
        "color": "#FF0097"
      },
      "date": {
        "color": "#FF0097",
        "fontSize": 9,
        "$hideLayer": true
      },
      "scale": {
        "default": 0.9,
        "withSeconds": 0.65,
        "Keypad": {
          "default": 0.7,
          "withSeconds": 0.45
        }
      },
      "topOffset": {
        "default": 5,
        "withSeconds": 15,
        "Keypad": {
          "default": 28,
          "withSeconds": 52
        }
      },
      "leftOffset": {
        "default": 5,
        "withSeconds": 0,
        "Keypad": {
          "default": 0,
          "withSeconds": 0
        }
      }
    }
  },
  {
    "name": "XL Firamono",
    "id": "firamono",
    "file": "firamono.svg",
    "type": "clockdigits",
    "preset": {
      "scale": {
        "default": 1,
        "withSeconds": 0.65,
        "Keypad": {
          "default": 0.74,
          "withSeconds": 0.47
        }
      },
      "topOffset": {
        "default": 0,
        "withSeconds": 15,
        "Keypad": {
          "default": 25,
          "withSeconds": 50
        }
      },
      "leftOffset": {
        "default": 0,
        "withSeconds": 0,
        "Keypad": {
          "default": 0,
          "withSeconds": 0
        }
      }
    }
  },
  {
    "name": "XL Londrina",
    "id": "londrina",
    "file": "londrina.svg",
    "type": "clockdigits",
    "preset": {
      "hours": {
        "color": "#6666FF",
        "$hideLayer": false
      },
      "minutes": {
        "color": "#6666FF",
        "$hideLayer": false
      },
      "seconds": {
        "color": "#6666FF",
        "$hideLayer": true
      },
      "colons": {
        "color": "#4444ee"
      },
      "date": {
        "color": "#6666FF",
        "fontSize": 11,
        "$hideLayer": true
      },
      "scale": {
        "default": 1,
        "withSeconds": 0.65,
        "Keypad": {
          "default": 0.74,
          "withSeconds": 0.47
        }
      },
      "topOffset": {
        "default": 0,
        "withSeconds": 15,
        "Keypad": {
          "default": 25,
          "withSeconds": 50
        }
      },
      "leftOffset": {
        "default": 0,
        "withSeconds": 0,
        "Keypad": {
          "default": 0,
          "withSeconds": 0
        }
      }
    }
  }
];
