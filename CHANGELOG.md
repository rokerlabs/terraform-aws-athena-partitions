## [1.0.3](https://github.com/rokerlabs/terraform-aws-athena-partitions/compare/v1.0.2...v1.0.3) (2021-07-15)


### Bug Fixes

* **artifact download:** only show errors for curl execution output ([309b575](https://github.com/rokerlabs/terraform-aws-athena-partitions/commit/309b5752b90b656eb40fc60ccaeac57013806585))

## [1.0.2](https://github.com/rokerlabs/terraform-aws-athena-partitions/compare/v1.0.1...v1.0.2) (2021-07-15)


### Bug Fixes

* **artifact download:** only download the artifact on version change to reduce diff noise ([51ee75c](https://github.com/rokerlabs/terraform-aws-athena-partitions/commit/51ee75c37650d7a4b75e3dcebf93ce3dd5845816))
* **lambda:** use the correct handler ([03aa645](https://github.com/rokerlabs/terraform-aws-athena-partitions/commit/03aa645dfef3fdac5dea100ba99dd761044cbfc0))

## [1.0.1](https://github.com/rokerlabs/terraform-aws-athena-partitions/compare/v1.0.0...v1.0.1) (2021-07-15)


### Bug Fixes

* **artifact download:** ensure the athena-partitions artifact is downloaded on lambda changes ([0d7b00f](https://github.com/rokerlabs/terraform-aws-athena-partitions/commit/0d7b00f32a5cdce5173dee7791fe989a097114f2))

# 1.0.0 (2021-07-15)


### Features

* **lambda:** create daily athena partitions for multiple log locations ([3a0f604](https://github.com/rokerlabs/terraform-aws-athena-partitions/commit/3a0f60400557b96d497c46f2274dd2aa14e0854f))
* **query result:** input for existing athena query result bucket locations ([d1f58ca](https://github.com/rokerlabs/terraform-aws-athena-partitions/commit/d1f58ca43909949a90c0fc2511529220ae7e6be9))
