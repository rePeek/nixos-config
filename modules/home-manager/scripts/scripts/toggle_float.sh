#!/usr/bin/env bash

hyprctl eval 'hl.dispatch(hl.dsp.window.float({ action = "toggle" })); hl.dispatch(hl.dsp.window.resize({ x = 1111, y = 700 })); hl.dispatch(hl.dsp.window.center())'
