CREATE EXTENSION plpython3u;

CREATE OR REPLACE FUNCTION get_median(value_array numeric[])
  RETURNS numeric AS
 $$
  import numpy as np
  return np.median(value_array)
$$ LANGUAGE plpython3u;

CREATE AGGREGATE agg_median(numeric) (
  SFUNC=array_append,
  STYPE=numeric[],
  FINALFUNC=get_median
);

--- Create aggregate for median absolute deviation
CREATE OR REPLACE FUNCTION get_mad(value_array numeric[])
  RETURNS numeric AS
 $$
  import numpy as np
  arr = np.ma.array(value_array).compressed()
  return np.mean(np.abs(arr - np.median(arr)))
$$ LANGUAGE plpython3u;

CREATE AGGREGATE agg_mad(numeric) (
  SFUNC=array_append,
  STYPE=numeric[],
  FINALFUNC=get_mad
);

-- Test execution
SELECT "group", AVG(value), agg_median(value), agg_mad(value) FROM public.testing_data group by "group"

-- Using window functions
SELECT distinct "group", AVG(value) over (partition by "group"), 
agg_median(value) over (partition by "group"), 
agg_mad(value) over (partition by "group") 
FROM public.testing_data
