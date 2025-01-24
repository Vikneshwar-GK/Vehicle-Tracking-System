create external schema dev_smartcity
from data catalog
database smartcity
iam_role '.....'
region '.....';

select * from dev_smartcity.gps_data
