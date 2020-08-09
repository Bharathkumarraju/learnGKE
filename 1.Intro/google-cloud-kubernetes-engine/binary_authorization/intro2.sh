cat > ./policy.yaml  << EOM
admissionWhitelistPatterns:
- namePattern: gcr.io/google_containers/*
- namePattern: gcr.io/google_containers/*
- namePattern: k8s.gcr.io/*
defaultAdmissionRule:
  evaluationMode: ALWAYS_DENY
  enforcementMode: ENFORCED_BLOCK_AND_AUDIT_LOG
EOM


bharathkumarraju@R77-NB193 binary_authorization % gcloud beta container binauthz policy import policy.yaml
admissionWhitelistPatterns:
- namePattern: gcr.io/google_containers/*
- namePattern: gcr.io/google_containers/*
- namePattern: k8s.gcr.io/*
defaultAdmissionRule:
  enforcementMode: ENFORCED_BLOCK_AND_AUDIT_LOG
  evaluationMode: ALWAYS_DENY
name: projects/srianjaneyam/policy
updateTime: '2020-08-09T00:12:45.297770Z'
bharathkumarraju@R77-NB193 binary_authorization %


bharathkumarraju@R77-NB193 binary_authorization % kubectl delete deployment --all
deployment.extensions "hello-bharath" deleted
bharathkumarraju@R77-NB193 binary_authorization %



bharathkumarraju@R77-NB193 binary_authorization % kubectl delete event --all
event "gke-binary-auth-cluster-default-pool-fc69f38d-4pdn.16296f45343e72cd" deleted
event "gke-binary-auth-cluster-default-pool-fc69f38d-4pdn.16296f45448e6811" deleted
event "gke-binary-auth-cluster-default-pool-fc69f38d-4pdn.16296f45448ea40d" deleted
event "gke-binary-auth-cluster-default-pool-fc69f38d-4pdn.16296f45448ec6fd" deleted
event "gke-binary-auth-cluster-default-pool-fc69f38d-4pdn.16296f4546f59a48" deleted
event "gke-binary-auth-cluster-default-pool-fc69f38d-4pdn.16296f4558434262" deleted
event "gke-binary-auth-cluster-default-pool-fc69f38d-4pdn.16296f45bdceb308" deleted
event "gke-binary-auth-cluster-default-pool-fc69f38d-4pdn.16296f4646e33793" deleted

bharathkumarraju@R77-NB193 binary_authorization %



bharathkumarraju@R77-NB193 binary_authorization % kubectl run --generator=deployment/apps.v1 hello-world  --image $CONTAINER_PATH
kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
deployment.apps/hello-world created
bharathkumarraju@R77-NB193 binary_authorization %


attestation:
---------------->

done by container analysys API

cat > ./create_note_request.json << EOM
{
  "name": "projects/${PROJECT_ID}/notes/${NOTE_ID}",
  "attestation_authority": {
    "hint": {
      "human_readable_name": "This note represents an attestation authority"
    }
  }
}
EOM

make curl request to container analysis API as below

curl -vvv -X POST \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
--data-binary @./create_note_request.json \
"https://containeranalysis.googleapis.com/v1alpha1/projects/${PROJECT_ID}/notes/?noteId=${NOTE_ID}"



curl -vvv  \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
"https://containeranalysis.googleapis.com/v1alpha1/projects/${PROJECT_ID}/notes/${NOTE_ID}"



bharathkumarraju@R77-NB193 binary_authorization % curl   \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
"https://containeranalysis.googleapis.com/v1alpha1/projects/${PROJECT_ID}/notes/${NOTE_ID}"
{
  "name": "projects/srianjaneyam/notes/bharath-attestor-note",
  "kind": "ATTESTATION_AUTHORITY",
  "createTime": "2020-08-09T03:06:05.902646Z",
  "updateTime": "2020-08-09T03:06:05.902646Z",
  "attestationAuthority": {
    "hint": {
      "humanReadableName": "This note represents an attestation authority"
    }
  }
}
bharathkumarraju@R77-NB193 binary_authorization %


bharathkumarraju@R77-NB193 binary_authorization % NOTE_ID=bharath-attestor-note
bharathkumarraju@R77-NB193 binary_authorization % echo $NOTE_ID
bharath-attestor-note
bharathkumarraju@R77-NB193 binary_authorization %


bharathkumarraju@R77-NB193 binary_authorization % ATTESTOR_ID=bharath-authz-attestor
bharathkumarraju@R77-NB193 binary_authorization % echo $ATTESTOR_ID
bharath-authz-attestor
bharathkumarraju@R77-NB193 binary_authorization %

bharathkumarraju@R77-NB193 binary_authorization % gcloud beta container binauthz attestors create $ATTESTOR_ID \
> --attestation-authority-note=$NOTE_ID \
> --attestation-authority-note-project=$PROJECT_ID
bharathkumarraju@R77-NB193 binary_authorization %


bharathkumarraju@R77-NB193 binary_authorization % gcloud beta container binauthz attestors list
┌────────────────────────┬───────────────────────────────────────────────────┬─────────────────┐
│          NAME          │                        NOTE                       │ NUM_PUBLIC_KEYS │
├────────────────────────┼───────────────────────────────────────────────────┼─────────────────┤
│ bharath-authz-attestor │ projects/srianjaneyam/notes/bharath-attestor-note │ 0               │
└────────────────────────┴───────────────────────────────────────────────────┴─────────────────┘
bharathkumarraju@R77-NB193 binary_authorization %

bharathkumarraju@R77-NB193 binary_authorization % PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
bharathkumarraju@R77-NB193 binary_authorization % echo $PROJECT_NUMBER
202016682554
bharathkumarraju@R77-NB193 binary_authorization %

harathkumarraju@R77-NB193 binary_authorization % BINAUTHZ_SA_EMAIL="service-${PROJECT_NUMBER}@gcp-sa-binaryauthorization.iam.gserviceaccount.com"
bharathkumarraju@R77-NB193 binary_authorization % echo $BINAUTHZ_SA_EMAIL
service-202016682554@gcp-sa-binaryauthorization.iam.gserviceaccount.com
bharathkumarraju@R77-NB193 binary_authorization %



Give Binary Authorization the permissions to view the note in the Container Analysis API -
BinAuth can query the API to verify that images have been attested or not

cat > ./iam_request.json << EOM
{
  'resource': 'projects/$PROJECT_ID/notes/$NOTE_ID',
  'policy': {
    'bindings': [
      {
        'role': 'roles/containeranalysis.notes.occurrences.viewer',
        'members': [
          'serviceAccount:$BINAUTHZ_SA_EMAIL'
        ]
      }
    ]
  }
EOM

curl -X POST \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
--data-binary @./iam_request.json \
"https://containeranalysis.googleapis.com/v1alpha1/projects/${PROJECT_ID}/notes/${NOTE_ID}:setIamPolicy"


bharathkumarraju@R77-NB193 binary_authorization % curl -X POST \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
--data-binary @./iam_request.json \
"https://containeranalysis.googleapis.com/v1alpha1/projects/${PROJECT_ID}/notes/${NOTE_ID}:setIamPolicy"
{
  "version": 1,
  "etag": "BwWsabeGyQw=",
  "bindings": [
    {
      "role": "roles/containeranalysis.notes.occurrences.viewer",
      "members": [
        "serviceAccount:service-202016682554@gcp-sa-binaryauthorization.iam.gserviceaccount.com"
      ]
    }
  ]
}
bharathkumarraju@R77-NB193 binary_authorization %





