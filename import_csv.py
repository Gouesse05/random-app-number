import csv
import json
import os

dossier = "/home/sdd/Téléchargements/Dataset"

for fichier in os.listdir(dossier):
    if fichier.lower().endswith(".csv"):
        chemin_csv = os.path.join(dossier, fichier)
        chemin_json = os.path.join(
            dossier,
            fichier.replace(".csv", ".json")
        )

        with open(chemin_csv, encoding="utf-8") as f:
            reader = csv.DictReader(f, delimiter=",")  # ← CSV avec en-têtes
            data = list(reader)

        with open(chemin_json, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=4)

        print(f"✔ {fichier} → {fichier.replace('.csv', '.json')}")

print("🎉 Conversion CSV → JSON terminée (FORMAT CORRECT)")
