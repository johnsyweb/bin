#!/usr/bin/env python

import json
import urllib2

def get_location(user):
    url = 'https://api.twitter.com/1/statuses/user_timeline.json?include_entities=true&include_rts=true&screen_name={0}&count=1'.format(user)
    result = urllib2.urlopen(url)
    stream = json.load(result)
    tweet = stream[0]
    user = tweet['user']
    return user['time_zone']

if __name__ == '__main__':
    import sys
    print get_location(sys.argv[-1])


