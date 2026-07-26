#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
transcribir_mis_audios.py
=====================================================================
Transcribe SOLO los 6 audios de WhatsApp indicados (no toca ningun
otro archivo de la carpeta). Salida en espanol.

USO:
    py transcribir_mis_audios.py

Si algun dia falla la libreria, instalala con:
    py -m pip install faster-whisper
=====================================================================
"""

import os

# Silencia el aviso de symlinks de Windows
os.environ["HF_HUB_DISABLE_SYMLINKS_WARNING"] = "1"

# --- CONFIGURACION ---------------------------------------------------
CARPETA = r"C:\Users\DELL\Downloads"          # carpeta donde estan los audios
MODELO  = "small"                              # tiny | base | small | medium | large-v3
IDIOMA  = "es"                                 # "es" espanol; "auto" para detectar

# Los 6 audios que se van a transcribir (SOLO estos):
ARCHIVOS = [
    "WhatsApp Ptt 2026-07-21 at 8.00.00 AM.ogg",
    "WhatsApp Ptt 2026-07-21 at 8.03.10 AM.ogg",
    "WhatsApp Ptt 2026-07-21 at 8.14.10 AM.ogg",
    "WhatsApp Ptt 2026-07-21 at 8.18.52 AM.ogg",
    "WhatsApp Ptt 2026-07-21 at 8.26.50 AM.ogg",
    "WhatsApp Ptt 2026-07-21 at 8.40.19 AM.ogg",
]
# --------------------------------------------------------------------


def main():
    try:
        from faster_whisper import WhisperModel
    except ImportError:
        print("Falta la libreria. Ejecuta:  py -m pip install faster-whisper")
        return

    # Arma la lista de rutas y avisa si alguna no existe
    rutas = []
    for nombre in ARCHIVOS:
        ruta = os.path.join(CARPETA, nombre)
        if os.path.isfile(ruta):
            rutas.append(ruta)
        else:
            print(f"[AVISO] No se encontro (se omite): {nombre}")

    if not rutas:
        print("No se encontro ninguno de los 6 audios en:", CARPETA)
        print("Revisa que CARPETA y los nombres sean correctos.")
        return

    print(f"Se transcribiran {len(rutas)} audios (solo los indicados).")
    print(f"Cargando modelo '{MODELO}'...")
    modelo = WhisperModel(MODELO, device="cpu", compute_type="int8")

    combinado = os.path.join(CARPETA, "TRANSCRIPCION_COMPLETA.txt")
    idioma = None if IDIOMA == "auto" else IDIOMA

    with open(combinado, "w", encoding="utf-8") as full:
        for i, ruta in enumerate(rutas, 1):
            nombre = os.path.basename(ruta)
            print(f"\n[{i}/{len(rutas)}] Transcribiendo: {nombre} ...")
            segmentos, info = modelo.transcribe(ruta, language=idioma, vad_filter=True)

            lineas, plano = [], []
            for s in segmentos:
                marca = f"[{int(s.start // 60):02d}:{int(s.start % 60):02d}]"
                lineas.append(f"{marca} {s.text.strip()}")
                plano.append(s.text.strip())
            texto = " ".join(plano)

            # .txt individual
            salida = os.path.splitext(ruta)[0] + ".txt"
            with open(salida, "w", encoding="utf-8") as f:
                f.write(f"Archivo: {nombre}\n")
                f.write(f"Duracion: {info.duration:.1f} s\n")
                f.write("-" * 50 + "\n\n")
                f.write("TEXTO CORRIDO:\n" + texto + "\n\n")
                f.write("CON MARCAS DE TIEMPO:\n" + "\n".join(lineas) + "\n")

            # bloque en el combinado
            full.write("=" * 60 + "\n")
            full.write(f"ARCHIVO: {nombre}\n")
            full.write("=" * 60 + "\n")
            full.write(texto + "\n\n")

            print("    OK ->", os.path.basename(salida))
            print("    Vista previa:", (texto[:120] + "...") if len(texto) > 120 else texto)

    print(f"\nLISTO. Todo junto en: {combinado}")


if __name__ == "__main__":
    main()
