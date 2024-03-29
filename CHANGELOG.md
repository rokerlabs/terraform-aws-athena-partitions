## [1.0.4](https://github.com/rokerlabs/terraform-aws-athena-partitions/compare/v1.0.3...v1.0.4) (2022-09-02)


### Bug Fixes

* **deps:** update module go to 1.19 ([#25](https://github.com/rokerlabs/terraform-aws-athena-partitions/issues/25)) ([e5707df](https://github.com/rokerlabs/terraform-aws-athena-partitions/commit/e5707df1a2326a8456191080958dc051d14b007e))

## [1.0.3](https://github.com/rokerlabs/terraform-aws-athena-partitions/compare/v1.0.2...v1.0.3) (2021-07-16)


### Bug Fixes

* **iam:** allow list bucket on all resources ([5c84d35](https://github.com/rokerlabs/terraform-aws-athena-partitions/commit/5c84d353fb9ad7340a4d43e2b26cd3c6ef7663fd))

## [1.0.2](https://github.com/rokerlabs/terraform-aws-athena-partitions/compare/v1.0.1...v1.0.2) (2021-07-16)


### Bug Fixes

* **partitions:** prepend '0' to single digit partition sections to use '01' instead of '1' ([6d7fc16](https://github.com/rokerlabs/terraform-aws-athena-partitions/commit/6d7fc16aa63c7e27a96c4cc89af604ad34ff79fa))

## [1.0.1](https://github.com/rokerlabs/terraform-aws-athena-partitions/compare/v1.0.0...v1.0.1) (2021-07-15)


### Bug Fixes

* **iam:** fixed arn s3:GetObject policy for existing query result locations ([defd361](https://github.com/rokerlabs/terraform-aws-athena-partitions/commit/defd3617d4e03f39ec833c9daa506593e65b77ce))

# 1.0.0 (2021-07-15)


### Bug Fixes

* **artifact download:** only download the artifact on version change to reduce diff noise ([51ee75c](https://github.com/rokerlabs/terraform-aws-athena-partitions/commit/51ee75c37650d7a4b75e3dcebf93ce3dd5845816))
* **iam:** set the correct iam permissions for query execution and result output ([7a07f42](https://github.com/rokerlabs/terraform-aws-athena-partitions/commit/7a07f425c554fcb1e410b52a5366121597626d4f))
* **lambda:** use the correct handler ([03aa645](https://github.com/rokerlabs/terraform-aws-athena-partitions/commit/03aa645dfef3fdac5dea100ba99dd761044cbfc0))


### Features

* **lambda:** create daily athena partitions for multiple log locations ([3a0f604](https://github.com/rokerlabs/terraform-aws-athena-partitions/commit/3a0f60400557b96d497c46f2274dd2aa14e0854f))
* **query result:** add input for existing athena query result bucket locations ([d1f58ca](https://github.com/rokerlabs/terraform-aws-athena-partitions/commit/d1f58ca43909949a90c0fc2511529220ae7e6be9))
