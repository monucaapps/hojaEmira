#!/usr/bin/env python3
"""
transcribir_audios.py
=====================================================================
Transcribe notas de voz / audios (WhatsApp .ogg, .mp3, .m4a, .wav, etc.)
a texto, en español, usando Whisper (motor faster-whisper) EN TU PC.

POR QUE EN TU PC:
    El modelo de voz se descarga la primera vez desde internet. En tu
    computadora funciona sin problema; en entornos con red restringida no.

-----------------------------------------------------------------
INSTALACION (una sola vez). Abre una terminal / CMD y ejecuta:

    pip install faster-whisper

    # ffmpeg NO suele hacer falta (faster-whisper trae su decodificador),
    # pero si algun audio raro falla, instala ffmpeg:
    #   Windows:  winget install Gyan.FFmpeg     (o https://ffmpeg.org)
    #   Mac:      brew install ffmpeg
    #   Linux:    sudo apt install ffmpeg

-----------------------------------------------------------------
USO:

    # 1) Transcribe TODOS los audios de la carpeta actual:
    python transcribir_audios.py

    # 2) Transcribe una carpeta especifica:
    python transcribir_audios.py "C:\\Users\\Jorge\\audios"

    # 3) Un solo archivo:
    python transcribir_audios.py "nota.ogg"

    # 4) Elegir tamano de modelo (mas grande = mas preciso pero mas lento):
    #    tiny | base | small | medium | large-v3
    python transcribir_audios.py "audios" --modelo medium

RESULTADO:
    - Un archivo .txt por cada audio (mismo nombre).
    - Un archivo  TRANSCRIPCION_COMPLETA.txt  con todo junto.
=====================================================================
"""

import sys
import os
import argparse

EXTS = (".ogg", ".opus", ".mp3", ".m4a", ".wav", ".aac", ".flac", ".mp4", ".webm")


def buscar_audios(ruta):
    """Devuelve la lista de audios a transcribir a partir de un archivo o carpeta."""
    if os.path.isfile(ruta):
        return [ruta]
    if os.path.isdir(ruta):
        archivos = []
        for nombre in sorted(os.listdir(ruta)):
            if nombre.lower().endswith(EXTS):
                archivos.append(os.path.join(ruta, nombre))
        return archivos
    print(f"[ERROR] No existe la ruta: {ruta}")
    return []


def main():
    parser = argparse.ArgumentParser(
        description="Transcribe audios a texto en espanol con Whisper."
    )
    parser.add_argument(
        "ruta", nargs="?", default=".",
        help="Archivo de audio o carpeta con audios (por defecto: carpeta actual)."
    )
    parser.add_argument(
        "--modelo", default="small",
        help="Tamano del modelo: tiny | base | small | medium | large-v3 (def: small)."
    )
    parser.add_argument(
        "--idioma", default="es",
        help="Codigo de idioma (def: es). Usa 'auto' para detectarlo."
    )
    args = parser.parse_args()

    try:
        from faster_whisper import WhisperModel
    except ImportError:
        print("=" * 60)
        print("Falta instalar la libreria. Ejecuta en tu terminal:")
        print("    pip install faster-whisper")
        print("=" * 60)
        sys.exit(1)

    audios = buscar_audios(args.ruta)
    if not audios:
        print("No se encontraron audios (.ogg .mp3 .m4a .wav ...) en:", args.ruta)
        sys.exit(1)

    print(f"Audios encontrados: {len(audios)}")
    print(f"Cargando modelo '{args.modelo}' (la 1a vez descarga ~cientos de MB)...")
    # int8 = rapido y ligero en CPU. Si tienes GPU NVIDIA: device='cuda'.
    modelo = WhisperModel(args.modelo, device="cpu", compute_type="int8")

    carpeta_base = args.ruta if os.path.isdir(args.ruta) else os.path.dirname(args.ruta) or "."
    combinado = os.path.join(carpeta_base, "TRANSCRIPCION_COMPLETA.txt")
    idioma = None if args.idioma == "auto" else args.idioma

    with open(combinado, "w", encoding="utf-8") as full:
        for i, audio in enumerate(audios, 1):
            nombre = os.path.basename(audio)
            print(f"\n[{i}/{len(audios)}] Transcribiendo: {nombre} ...")
            segmentos, info = modelo.transcribe(audio, language=idioma, vad_filter=True)

            lineas = []
            texto_plano = []
            for s in segmentos:
                marca = f"[{int(s.start // 60):02d}:{int(s.start % 60):02d}]"
                lineas.append(f"{marca} {s.text.strip()}")
                texto_plano.append(s.text.strip())

            cuerpo = "\n".join(lineas)
            plano = " ".join(texto_plano)

            # .txt individual
            salida_txt = os.path.splitext(audio)[0] + ".txt"
            with open(salida_txt, "w", encoding="utf-8") as f:
                f.write(f"Archivo: {nombre}\n")
                f.write(f"Idioma detectado: {info.language} (prob {info.language_probability:.2f})\n")
                f.write(f"Duracion: {info.duration:.1f} s\n")
                f.write("-" * 50 + "\n\n")
                f.write("TEXTO CORRIDO:\n" + plano + "\n\n")
                f.write("CON MARCAS DE TIEMPO:\n" + cuerpo + "\n")

            # bloque en el combinado
            full.write("=" * 60 + "\n")
            full.write(f"ARCHIVO: {nombre}\n")
            full.write("=" * 60 + "\n")
            full.write(plano + "\n\n")

            print(f"    -> {os.path.basename(salida_txt)}")
            print("    Vista previa:", (plano[:120] + "...") if len(plano) > 120 else plano)

    print(f"\nLISTO. Transcripcion completa en: {combinado}")


if __name__ == "__main__":
    main()
