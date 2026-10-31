import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

REMEDIATED = {
    "AWS-0086",
    "AWS-0087",
    "AWS-0091",
    "AWS-0093",
    "AWS-0107",
}

KNOWN_REMAINING = {
    "AWS-0089",
    "AWS-0090",
    "AWS-0132",
}


def load_findings(name):
    path = ROOT / "reports" / f"trivy-{name}.json"

    with path.open(encoding="utf-8") as file:
        report = json.load(file)

    if not isinstance(report.get("Results"), list):
        raise ValueError(f"Invalid Trivy report: {path}")

    findings = set()

    for result in report["Results"]:
        for item in result.get("Misconfigurations") or []:
            if item.get("Status") == "FAIL":
                finding_id = item.get("ID")
                if not finding_id:
                    raise ValueError("Finding is missing an ID")
                findings.add(finding_id)

    return findings


def main():
    insecure = load_findings("insecure")
    secure = load_findings("secure")

    print("TRIVY SECURITY REGRESSION TEST")
    print(f"Insecure finding IDs: {sorted(insecure)}")
    print(f"Secure finding IDs: {sorted(secure)}")

    missing = REMEDIATED - insecure
    unresolved = REMEDIATED & secure
    unexpected = secure - KNOWN_REMAINING

    if missing:
        print(f"FAIL: Expected detections missing: {sorted(missing)}")

    if unresolved:
        print(f"FAIL: Remediated issues remain: {sorted(unresolved)}")

    if unexpected:
        print(f"FAIL: New findings require review: {sorted(unexpected)}")

    if missing or unresolved or unexpected:
        return 1

    print("PASS: All five expected vulnerabilities detected")
    print("PASS: Remediated issues absent from secure configuration")
    print(f"KNOWN LAB LIMITATIONS: {sorted(secure)}")
    print("SUCCESS: Trivy security regression tests passed")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, json.JSONDecodeError) as error:
        print(f"FAIL: Unable to validate Trivy reports: {error}")
        sys.exit(1)
