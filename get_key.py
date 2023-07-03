def get_value_by_key(obj, key):
    keys = key.split("/")
    val = obj
    for k in keys:
        if k in val:
            val = val[k]
        else:
            return None
    return val
