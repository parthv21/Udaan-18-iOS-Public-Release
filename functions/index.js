const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

exports.notifyUserAdd = functions.auth.user().onCreate( event => {
        
        console.log("New user added.");

        const user = event.data
        const displayName = user.displayName
        var tokenArr = []

        var db = admin.database();
        var ref = db.ref("/iOS/CommitteeTokens");
        
        ref.on("value",function(snpashot){
            var tokens = snpashot.val()
          
            for (var key in tokens) {
                if (tokens.hasOwnProperty(key)) {
                    
                    if (key == "Parth Tamane") {
                        console.log("Found parth");
                        tokenArr.push(tokens[key]);
                    }
                }
            }
            console.log("Array of tokens: " + tokenArr)

            const payload = {
                notification:
                {
                    title: "New User Added!",
                    body: displayName+" just logged on to Udaan App!",
                    sound: "default"
                }
            }
    
            admin.messaging().sendToDevice(tokenArr,payload).then(function(response) {
                
                console.log("Successfully sent message:", response);
            })
            .catch(function(error) {
                console.log("Error sending message:", error);
            });
    

        }, function (errorObject) {
            console.log("The read failed: " + errorObject.code);
          })
        
        return 0    
    }
)


exports.sendNotification = functions.database.ref("/iOS/Messages/{autoId}/").onCreate(event => {
    
    //console.log(`Auto id is: ${event.params.autoId}`);
    //console.log(`Event is ${event}`);

    const current = event.data.val();
  
    const receiever = current.rec_email
    const message = current.text
    const name = current.name
    const tokens = current.rec_tokens
    const payload = {
        notification:
        {
            title: name,
            body: message,
            sound: "default"
        }
    }
    const topic = "notif"

    console.log(`Token(s) receieved are: ${tokens}`)
    console.log(`Receiever is: ${receiever}`)

    if (receiever == "All" ) {

        console.log("Will notify all users!")
        admin.messaging().sendToTopic(topic, payload)
        .then(function(response) {
        // See the MessagingTopicResponse reference documentation for the
        // contents of response.
            console.log("Successfully sent message:", response);
        })
            .catch(function(error) {
                console.log("Error sending message:", error);
        });

    } else {

        console.log("Will notify committee:");
        admin.messaging().sendToDevice(tokens, payload)
        .then(function(response) {
            // See the MessagingDevicesResponse reference documentation for
            // the contents of response.
            console.log("Successfully sent message:", response);
        })
        .catch(function(error) {
            console.log("Error sending message:", error);
        });

    }
     
    //console.log(`Message is: ${JSON.stringify(current.text,undefined,2)}`)

    //const stringJson = JSON.stringify(current)
    //console.log(`Full message objet is: \n${stringJson}`)

    return 0;
})
