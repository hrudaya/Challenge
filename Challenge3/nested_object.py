# getkey value should be passed and it will return
# if user passes getkey = 'a', value will be {'b': {'c': 'd'}}
# if user passes getkey = 'b', value will be {'c': 'd'}
# if user passes getkey = 'c', value will be d

def recursive_items(dictionary):
    for key, value in dictionary.items():
        if type(value) is dict:
            yield (key, value)
            yield from recursive_items(value)
        else:
            yield (key, value)

object = {'a': { 'b': {'c': 'd' } } }
getkey = 'b'

for key, value in recursive_items(object):
    if getkey in key:
       print(value)
