Below all steps in cloudshell:
----------------------------------->

sudo apt-get install rng-tools -y
bharath@cloudshell:~$ ps -eaf | grep -i rngd
root         900       1  0 13:02 ?        00:00:00 rngd -r /dev/urandom
bharath      911     460  0 13:03 pts/1    00:00:00 grep --color=auto -i rngd
bharath@cloudshell:~$ gpg --batch --gen-key <(
> cat <<- EOF
> Key-Type: RSA
> Key-Length: 2048
> Name-Real: Demo Signing Role
> Name-Email: bharath@bharathkumaraju.com
> %commit
> EOF
> )
gpg: directory '/home/bharath/.gnupg' created
gpg: keybox '/home/bharath/.gnupg/pubring.kbx' created
gpg: /home/bharath/.gnupg/trustdb.gpg: trustdb created
gpg: key FF10D9820CA0F815 marked as ultimately trusted
gpg: directory '/home/bharath/.gnupg/openpgp-revocs.d' created
gpg: revocation certificate stored as '/home/bharath/.gnupg/openpgp-revocs.d/047A4078247A9ED2CEFE5241FF10D9820CA0F815.rev'
bharath@cloudshell:~$


bharath@cloudshell:~$ gpg --armor --export bharath@bharathkumaraju.com > ./public.pgp
bharath@cloudshell:~$ ls -rtlh
total 484K
-rw-r--r-- 1 bharath rvm      16K Jun 23 13:54 test.json
-rw-r--r-- 1 bharath rvm     210K Jun 23 14:02 all_org_permissions.json
-rw-r--r-- 1 bharath rvm     233K Jun 23 14:05 all_project_permissions.json
-rw-r--r-- 1 bharath rvm      756 Jun 23 14:46 policies.yml
drwxr-xr-x 2 bharath bharath 4.0K Jul  6 06:06 test_http_trigger_function
-rw-r--r-- 1 bharath bharath   66 Jul 11 10:42 1
-rw-r--r-- 1 bharath rvm      913 Aug  9 13:01 README-cloudshell.txt
-rw-r--r-- 1 bharath bharath  973 Aug  9 13:06 public.pgp
bharath@cloudshell:~$



bharathkumarraju@R77-NB193 binary_authorization % cp ~/Downloads/public.pgp .
bharathkumarraju@R77-NB193 binary_authorization % gcloud beta container binauthz attestors public-keys add \
--attestor=$ATTESTOR_ID --pgp-public-key-file=./public.pgp
asciiArmoredPgpPublicKey: |
  -----BEGIN PGP PUBLIC KEY BLOCK-----

  mQENBF8vg98BCACpf1mGdGVAYWGFS4aJgaJuh7hCxwxQ/103tsVAsG7ZXMH8HgX8
  0mpUCsjPPHVs9/NZoGTCdesMjluIaJ8trOPgOmx+RhtxI6Kj8H0SFCgSYqm2Sh07
  W/wnL3kJPm0mt7p3UKo/pKhrHAeghNcBGFQ5ybLPmAy/muuu65a7ZMzOzIx9ANFl
  /H+ZyOoG8GlhyqWgH1UhDoKL+pQWA5FwJFoGKUk9qjVOsVG6FyxzmADTxKfoDzke
  E9+opds7ofJi3d9fAU8KAzhU31B8Dhx6sX6lHiV4RzVJtadSiKb9i4yKByp0cXAr
  hyRMNGzWFlf+1zg4ZdqM/CuMTFqWUbRSiPhHABEBAAG0L0RlbW8gU2lnbmluZyBS
  b2xlIDxiaGFyYXRoQGJoYXJhdGhrdW1hcmFqdS5jb20+iQFOBBMBCgA4FiEEBHpA
  eCR6ntLO/lJB/xDZggyg+BUFAl8vg98CGy8FCwkIBwIGFQoJCAsCBBYCAwECHgEC
  F4AACgkQ/xDZggyg+BUUPAf/ZzqNkeIJHIrxl26tI8tb5ub6Jw5QzFcd7qCGTf2o
  lK2q1TcroN+qn/qLeDDk2FOSceLABkUVbh51OvqwLA8+N2XMdlYWvO2qij1HslOh
  j1UvEgXtzy99F2YbjJqjbBWLCmdoooBYDdN8tu3q8ZTzjR2dUfcr9tA80YJk2Rhq
  o4QAQq2kzDD5G1gHP0tVOEQ7eq2kj+SpU3ld+JOhZkH8YYkxHT8l1SoI2PigmU90
  qq3elwEWIhPPuZG2mdeJU3ubFTa63S/kNG0p2fX3CCvOvZkzCaLGhhP/OdGjjU37
  qptM5cLYN899kSUUuWeKREKqnsdeYAPiX21BmpVQRhV9vQ==
  =WC09
  -----END PGP PUBLIC KEY BLOCK-----
id: 047A4078247A9ED2CEFE5241FF10D9820CA0F815
bharathkumarraju@R77-NB193 binary_authorization %

bharathkumarraju@R77-NB193 binary_authorization % gcloud beta container binauthz attestors list
┌────────────────────────┬───────────────────────────────────────────────────┬─────────────────┐
│          NAME          │                        NOTE                       │ NUM_PUBLIC_KEYS │
├────────────────────────┼───────────────────────────────────────────────────┼─────────────────┤
│ bharath-authz-attestor │ projects/srianjaneyam/notes/bharath-attestor-note │ 1               │
└────────────────────────┴───────────────────────────────────────────────────┴─────────────────┘
bharathkumarraju@R77-NB193 binary_authorization %

Now get the digest of the container image so we can sign it using the cryptographic key we just


bharathkumarraju@R77-NB193 binary_authorization % echo $CONTAINER_PATH
us.gcr.io/srianjaneyam/hello-world

bharathkumarraju@R77-NB193 binary_authorization % gcloud container images describe $CONTAINER_PATH
image_summary:
  digest: sha256:35a70bdb7394af1b8c317cdcbb4c9b5560dbb165b53848fee7f77ab59f3e0724
  fully_qualified_digest: us.gcr.io/srianjaneyam/hello-world@sha256:35a70bdb7394af1b8c317cdcbb4c9b5560dbb165b53848fee7f77ab59f3e0724
  registry: us.gcr.io
  repository: srianjaneyam/hello-world


bharathkumarraju@R77-NB193 binary_authorization % gcloud container images describe ${CONTAINER_PATH}:latest \
> --format='get(image_summary.digest)'
sha256:35a70bdb7394af1b8c317cdcbb4c9b5560dbb165b53848fee7f77ab59f3e0724

bharathkumarraju@R77-NB193 binary_authorization % DIGEST=$(gcloud container images describe ${CONTAINER_PATH}:latest \
--format='get(image_summary.digest)')
bharathkumarraju@R77-NB193 binary_authorization % echo $DIGEST
sha256:35a70bdb7394af1b8c317cdcbb4c9b5560dbb165b53848fee7f77ab59f3e0724
bharathkumarraju@R77-NB193 binary_authorization %

Generate a JSON payload file to represent the container to be signed.


Sign the payload:
-------------------->
this approves the image represented by the payload.

bharath@cloudshell:~$ gpg --local-user bharath@bharathkumaraju.com --armor --output ./signature.pgp --sign ./payload.json
bharath@cloudshell:~$


bharath@cloudshell:~$ gpg --list-keys
/home/bharath/.gnupg/pubring.kbx
--------------------------------
pub   rsa2048 2020-08-09 [SCEA]
      047A4078247A9ED2CEFE5241FF10D9820CA0F815
uid           [ultimate] Demo Signing Role <bharath@bharathkumaraju.com>


bharath@cloudshell:~$ gpg --list-keys bharath@bharathkumaraju.com | sed -n  '2p'
      047A4078247A9ED2CEFE5241FF10D9820CA0F815
bharath@cloudshell:~$

bharath@cloudshell:~$ KEY_FINGERPRINT=$(gpg --list-keys bharath@bharathkumaraju.com | sed -n  '2p')

bharath@cloudshell:~$ echo $KEY_FINGERPRINT
047A4078247A9ED2CEFE5241FF10D9820CA0F815
bharath@cloudshell:~$



gcloud beta container binauthz attestations create \
--artifact-url="${CONTAINER_PATH}@${DIGEST}" \
--attestor=${ATTESTOR_ID} \
--attestor-project=${PROJECT_ID} \
--signature-file=./signature.pgp \
--pgp-key-fingerprint="${KEY_FINGERPRINT}"


$ gcloud beta container binauthz attestations create \
    --project=${PROJECT_ID} \
    --artifact-url="${CONTAINER_PATH}@${DIGEST}" \
    --attestor=${ATTESTOR_ID} \
    --signature-file=./signature.pgp \
    --public-key-id=${KEY_FINGERPRINT}


bharathkumarraju@R77-NB193 binary_authorization % gcloud beta container binauthz attestations list --attestor=$ATTESTOR_ID --attestor-project=$PROJECT_ID
---
attestation:
  serializedPayload: ewogICJjcml0aWNhbCI6IHsKICAgICJpZGVudGl0eSI6IHsKICAgICAgImRvY2tlci1yZWZlcmVuY2UiOiAidXMuZ2NyLmlvL3NyaWFuamFuZXlhbS9oZWxsby13b3JsZCIKICAgIH0sCiAgICAiaW1hZ2UiOiB7CiAgICAgICJkb2NrZXItbWFuaWZlc3QtZGlnZXN0IjogInNoYTI1NjozNWE3MGJkYjczOTRhZjFiOGMzMTdjZGNiYjRjOWI1NTYwZGJiMTY1YjUzODQ4ZmVlN2Y3N2FiNTlmM2UwNzI0IgogICAgfSwKICAgICJ0eXBlIjogIkdvb2dsZSBjbG91ZCBiaW5hdXRoeiBjb250YWluZXIgc2lnbmF0dXJlIgogIH0KfQo=
  signatures:
  - publicKeyId: 047A4078247A9ED2CEFE5241FF10D9820CA0F815
    signature: LS0tLS1CRUdJTiBQR1AgTUVTU0FHRS0tLS0tCgpvd0did012TXdNWDRYK0JtRTgrQ0g2S01heG10a25nS0VpdHo4aE5UOUxLSzgvUGk5US8wVkhNcEtDZ2xGMldXClpDWW41aWhaS1lENFFKSE1sTlM4a3N5U1NyZ0lVQ3dsUHprN3RVaTNLRFV0dFNnMUx6a1ZLS2RVV3F5WG5seWsKbDVtdlgxeVVtWmlYbFppWFdwbVlxNStSbXBPVHIxdWVYNVNUb2dUV1hxc0ROVGMzTVQwVmk2RzVpWG1aYWFuRgpKYm9wbWVsQUNtUjBjVWFpa2FtWmxiRnBvcmxCVWtxU3ViR2xTV0thWVpKRnNyR2hlWEpLY2xLU1NiSmxrcW1wCm1VRktVcEtobVdtU3FiR0ZpVVZhYXFwNW1ybDVZcEtwWlpweHFvRzVrUW1xL1NXVkJXQjN1K2ZucCtla0tpVG4KNUplbUtDUmw1aVdXbG1SVUtTVG41NVVrWnVhbEZpa1VaNmJuSlphVUZxV0N0TmR5MVhKMU1nYXdNREJ5TVZpSgpLYkt3VkRsVXFGVE51M1R1WDVBakxIUlptVUNoS1NPVGxKRllsRmlTNFFDbHMwdHpnWFJXcVY1eWZpNERGNmNBClRMbk5WUTZHcFplMnoyS2RyaVJ4bHl2cnk0YjNXMmZ1ZkpIeVFtMjJERnQzT2tmY3hnbi85UzBrTHBRSTVhK0oKS1k5cW5qVkhzRVRsNjFyYmF2SFNDbkg1T3BsT2lXZnpmVjRyVHBQNUZOWm5zeTlPOEp2cWhaQm50eGcyUjNCZgpsOURLL2J4Uk9DN1c3UDNYaDRjRFgzZi8ydmR0bnRJVFlmbjcrdE5lY1Rpc09jTThnV05LNWVKL1g0MWIxdmpWCkh6KzArQXg3Uys2WnYyY2Y5OFJPVjk5dzk4bi9UeHp1dG5YMjJ5Wm9OYjNJdUY2K01PRkNncHZPVlBWZzY5UlYKZkV3blRtNDlwelpCSzNyRmEzMitGVHNtRkduOGQrUGIrV2lsejhlLy9TNU4vU3U0RktybUMwb2xwenpJM216SAoyNXYveldIdDZyOTh0NnU0THZlbHI5d2lKbklydGFGcDR2ckYxd3BEVkQ5cWRNNWxBZ0E9Cj1DYkNtCi0tLS0tRU5EIFBHUCBNRVNTQUdFLS0tLS0K
createTime: '2020-08-09T13:34:41.370954Z'
kind: ATTESTATION
name: projects/srianjaneyam/occurrences/9276fd1b-ada4-4228-999c-6117511fb3f8
noteName: projects/srianjaneyam/notes/bharath-attestor-note
resourceUri: https://us.gcr.io/srianjaneyam/hello-world@sha256:35a70bdb7394af1b8c317cdcbb4c9b5560dbb165b53848fee7f77ab59f3e0724
updateTime: '2020-08-09T13:34:41.370954Z'
bharathkumarraju@R77-NB193 binary_authorization %


bharathkumarraju@R77-NB193 binary_authorization % gcloud beta container binauthz policy import updated_policy.yaml
admissionWhitelistPatterns:
- namePattern: gcr.io/google_containers/*
- namePattern: k8s.gcr.io/*
defaultAdmissionRule:
  enforcementMode: ENFORCED_BLOCK_AND_AUDIT_LOG
  evaluationMode: REQUIRE_ATTESTATION
  requireAttestationsBy:
  - projects/srianjaneyam/attestors/bharath-authz-attestor
name: projects/srianjaneyam/policy
updateTime: '2020-08-09T13:51:00.740307Z'
bharathkumarraju@R77-NB193 binary_authorization %

