/**
 * Copyright 2014 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

var assert = require('assert'),
    async = require('async');

var env = require('./env.js'),
    gcloud = require('../lib');

var topicNames = ['topic1', 'topic2', 'topic3'];
var subscriptions = [{
  name: 'sub1',
  ackDeadlineSeconds: 30
}, {
  name: 'sub2',
  ackDeadlineSeconds: 60
}];

var conn = new gcloud.pubsub.Connection(env);

before(function(done) {
  // TODO: Handle pagination.
  var createFn = function(name, callback) {
    conn.createTopic(name, callback);
  };
  conn.listTopics(function(err, topics) {
    if (err) { return done(err); }
    var fns = topics.map(function(t) {
      return function(cb) {
        t.del(cb);
      };
    });
    async.parallel(fns, function(err) {
      if (err) { return done(err); }
      async.map(topicNames, createFn, done);
    });
  })
});

describe('Topic', function() {

  it('should be listed', function(done) {
    conn.listTopics(function(err, topics) {
      assert(topics.length, 3);
      done(err);
    });
  });

  it('should return a nextQuery if there are more results', function(done) {
    conn.listTopics({ maxResults: 2 }, function(err, topics, next) {
      assert(topics.length, 2);
      assert(next.maxResults, 2);
      assert(!!next.pageToken, true);
      done(err);
    });
  })

  it('should be created', function(done) {
    conn.createTopic('topic-new', done);
  });

  it('should be gettable', function(done) {
    conn.getTopic('topic1', done);
  });

  it('should publish a message', function(done) {
    conn.getTopic('topic1', function(err, topic) {
      topic.publish('message from me', done);
    });
  });

  it('should be deleted', function(done) {
    conn.getTopic('topic3', function(err, topic) {
      topic.del(done);
    });
  });

});

describe('Subscription', function() {

  before(function(done) {
    var createFn = function(item, callback) {
      conn.createSubscription({
        name: item.name,
        topic: 'topic1',
        ackDeadlineSeconds: item.ackDeadlineSeconds
      }, callback);
    };
    conn.listSubscriptions(function(err, subs) {
      if (err) {
        done(err); return;
      }
      var fns = subs.map(function(sub) {
        return function(cb) {
          sub.del(cb);
        };
      });
      async.series(fns, function(err) {
        if (err) {
          done(err); return;
        }
        async.map(subscriptions, createFn, done);
      });
    })
  });

  it('should be listed', function(done) {
    conn.listSubscriptions(function(err, subs) {
      assert.strictEqual(subs.length, 2);
      done(err);
    });
  });

  it('should be gettable', function(done) {
    conn.getSubscription('sub1', function(err, sub) {
      if (err) {
        done(err); return;
      }
      assert.strictEqual(sub.name, '/subscriptions/' + env.projectId + '/sub1');
      done();
    });
  });

  it('should error while getting a non-existent subscription', function(done){
    conn.getSubscription('sub-nothing-is-here', function(err, sub) {
      assert.strictEqual(err.code, 404);
      done();
    });
  });

  it('should be created', function(done) {
    conn.createSubscription({
      topic: 'topic1',
      name: 'new-sub'
    }, done);
  });

  it.skip('should be able to pull and ack', function(done) {
    conn.getTopic('topic1', function(err, topic) {
      if (err) {
        done(err); return;
      }
      topic.publish('hello', function(err) {
        if(err) done(err); return;
      });
    });
    conn.getSubscription('sub1', function(err, sub) {
      if (err) {
        done(err); return;
      }
      sub.on('message', function(msg) {
        sub.ack(msg.ackId, done);
      });
      sub.pull({}, done);
    });
  });

});
