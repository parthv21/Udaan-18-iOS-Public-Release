# Udaan App
iOS app for college cultural festival Udaan.

 https://itunes.apple.com/us/app/udaan-18/id1330313148?ls=1&mt=8 <br>
 
You will have to add your own info.plist file for backend connectivity to work. I have removed all the asset files so most UI elements will appear blank. Also for google cloud functions to work you will have to install the node modules and also initialize a connection to the project on fire base using Firebase CLI.

> Install Pods
<br> 
pod install


> Create a firebase project 

Add email aunthentication
Link it to the app

Back end should look like this:

```
{
  "iOS": {
    "CommitteeTokens": {
      "Parth Tamane": "dZRUKaCL6dg:APA91bGXs5uhYMpDhpeKnIhSUKxjPw8yYwQ1VVYeHepT80Y38MZLIvSs1z6wQmnbH6wIxDsIpNnr2gkBdpSlE0SruXE5YNrAHlyYXLK4qTdyOxYsj_r0-ZlWNbOHpzJXjgbaRmp59vrm"
    },
    "Events": {
      "Categories": [
        "Featured",
        "Performing Arts",
        "Litrary Arts",
        "Fun Events"
      ],
      "Categories-BG": [
        "https://firebasestorage.googleapis.com/v0/b/udaan-18.appspot.com/o/FeE.jpg?alt=media&token=f9cf9576-d0b4-4e48-ace1-3274a99b3b74",
        "https://firebasestorage.googleapis.com/v0/b/udaan-18.appspot.com/o/PA.jpg?alt=media&token=369f1a5d-a09e-431a-8bcf-c92687c0d415",
        "https://firebasestorage.googleapis.com/v0/b/udaan-18.appspot.com/o/LA.jpg?alt=media&token=211bfe22-a867-479e-a21c-b33a5769b81d",
        "https://firebasestorage.googleapis.com/v0/b/udaan-18.appspot.com/o/FE.jpg?alt=media&token=ade9558d-61a0-4eb4-925f-2ab8c1a00357"
      ],
      "Regestrations": {
        "cat-0": {
          "eve-1": {
            "GthuAo5OArbPy1SRINp1cWmQbqf1": {
              "name": "Nishant Bakhrey"
            },
            "ZzL4c8u4s1VAmfNn2x81ltuDNGv2": {
              "name": "Aditya Bhave"
            },
            "mYdDtghSOWR6kAhFehWPrgS8STi2": {
              "name": "Parth T"
            },
            "y0Kd1bKtm7aOmDXHAAHtnaZVad43": {
              "name": "Parth Tamane"
            }
          },
          "eve-3": {
            "ZzL4c8u4s1VAmfNn2x81ltuDNGv2": {
              "name": "Aditya Bhave"
            },
            "xOoYNIDFeuMQL2QNAbYDbmcq8wR2": {
              "name": "anmol pandita"
            },
            "y0Kd1bKtm7aOmDXHAAHtnaZVad43": {
              "name": "Parth Tamane"
            }
          },
          "eve-4": {
            "ZzL4c8u4s1VAmfNn2x81ltuDNGv2": {
              "name": "Aditya Bhave"
            }
          }
        },
        "cat-1": {
          "eve-3": {
            "y0Kd1bKtm7aOmDXHAAHtnaZVad43": {
              "name": "Parth Tamane"
            }
          }
        },
        "cat-3": {
          "eve-3": {
            "WxmzilnZnZcqsdEgXF55BmCZEOq1": {
              "name": "Vishakha Kalal"
            }
          },
          "eve-6": {
            "ThcRVw5k23VLw0OVx8cTlAiIfeq2": {
              "name": "Kshitij Shah"
            }
          }
        }
      },
      "SubEvents": [
        [
          "Featured",
          {
            "categoryId": 0,
            "contact": "8879771137",
            "contact2": "9833559610",
            "cost": 50,
            "date": "14/02/18",
            "description": "To celebrate that truth, S.P.I.T's Udaan brings you \"Open Mic\", an evening filled with music, poetry and laughter to get your mind off the books",
            "email": "abc@gmail.com",
            "eventId": 1,
            "name": "Openmic",
            "organizer": "Vidushi Razdan",
            "organizer2": "Darshana Mehta",
            "poster": "https://firebasestorage.googleapis.com/v0/b/udaan-18.appspot.com/o/Open%20Mic%20Night.jpg?alt=media&token=f6c1c804-cc9c-4fb4-990e-af988a9c3179",
            "prize": "NA",
            "room": "Quad"
          }
        ],
        [
          "Performing Arts",
          {
            "categoryId": 1,
            "contact": "7738436429",
            "contact2": "9820952462",
            "cost": 650,
            "date": "17 Feb (2PM Onwards)",
            "description": "STREET DANCE is an event which comprises of  a range of dance styles characterised by descriptions such as hip hop, funk and breakdancing.",
            "email": "",
            "eventId": 1,
            "name": "Street Dance",
            "organizer": "Jaswant",
            "organizer2": "Meet ",
            "poster": "https://firebasestorage.googleapis.com/v0/b/udaan-18.appspot.com/o/street%20dance.png?alt=media&token=ec6eb7bd-33dc-42b8-a66b-37db3e048630",
            "prize": "Worth ₹20000",
            "room": "Enterance"
          }
        ],
        [
          "Litrary Arts",
          {
            "categoryId": 2,
            "contact": "9920475962",
            "contact2": "9821474378",
            "cost": "1500",
            "description": "Model United Nations, also known as Model UN or MUN, is an extra-curricular activity.  ",
            "email": "",
            "eventId": 1,
            "name": "SPIT MUN",
            "organizer": "Rithvika Iyer",
            "organizer2": "Siddhesh Pai",
            "poster": "https://firebasestorage.googleapis.com/v0/b/udaan2k18.appspot.com/o/EventPosters%2Fmunlgog.jpg?alt=media&token=7173a574-f3a7-4b6f-abce-0f80644400de",
            "room": "SPIT"
          },
          {
            "categoryId": 2,
            "contact": "8879113063",
            "contact2": "9930634696",
            "cost": "-",
            "date": "17 Feb (1-6PM), 18 Feb (10AM-3PM)",
            "description": "An Oxford Style Panel Debate.",
            "email": "",
            "eventId": 3,
            "name": "SPITfire 2018",
            "organizer": "Azain Jaffer",
            "organizer2": "Harsh Dave",
            "poster": "https://firebasestorage.googleapis.com/v0/b/udaan-18.appspot.com/o/spitfire%20panel%20debate.jpg?alt=media&token=cac4d170-78ba-41f9-a4d1-5c97a1ae4cbd",
            "prize": "₹9,000 Winners,₹6000 Runner-Up",
            "room": "SPIT"
          }
        ],
        [
          "Fun Events",
          {
            "categoryId": 3,
            "contact": "9920133885",
            "contact2": "9820727713",
            "cost": "-",
            "date": "17,18 Feb (10AM-6PM)",
            "description": "A casino based event to please the gambler inside you. Come test both your skill and luck with games like Texas holde'm poker, blackjack, 7up 7down and more. ",
            "email": "",
            "eventId": 1,
            "name": "Casino",
            "organizer": "Kevin Sijo",
            "organizer2": "Adhrit Shetty ",
            "poster": "https://firebasestorage.googleapis.com/v0/b/udaan-18.appspot.com/o/Casino.jpg?alt=media&token=03544cd8-1e2a-4798-bc88-b0c6dd46f747",
            "prize": "With the right skills it can all be yours",
            "room": "FE COMPS"
          }
        ]
      ]
    },
    "QuestionSet": {
      "010118": [
        null,
        {
          "ans": 3,
          "longOption": true,
          "op1": "Community",
          "op2": "Two And A Half Men",
          "op3": "Rick and Morty",
          "op4": "How I Met Your Mother",
          "qes": "Waba Laba Dub Dub!"
        }
      ]
    },
    "Messages": {
      "-L3kl9DAWIVt3SpG0SmO": {
        "email": "parthv21@gmail.com",
        "name": "Parth Tamane",
        "rec_email": "All",
        "rec_name": "All",
        "rec_tokens": [
          "All"
        ],
        "text": "If you open the app right now, you will notice no images are loading. This is because of my storage quota exceeding, I'm working to fix this so it will not be an issue in the next update. The quota should reset in a day... ",
        "time": 1516941648.909397,
        "token": "cpwYfYIP7Wo:APA91bG7-NUbcYZwJWH8FZqvqbY0xNCJHQap9yUMTzGdIZ10kcqZI-TsLA6LUnKuDMj0SmQKs72YG-6sUyFi-9jTYv9bA9PMQlH9qwQPBI2GNCBIffS4YNyhlSyC81YOTIRmziIW5XVl"
      }
    },
    "Sponsors": {
      "1-Newspaper Media": [
        {
          "link": "https://maharashtratimes.indiatimes.com",
          "logo": "https://firebasestorage.googleapis.com/v0/b/udaan-18.appspot.com/o/MT.jpg?alt=media&token=7cdd4dce-6f88-442e-b57b-ab23b6c46d84",
          "name": "Maharashtra Times"
        }
      ],
      "2-Fitness Partner": [
        {
          "link": "http://www.yourfitnessclub.in",
          "logo": "https://firebasestorage.googleapis.com/v0/b/udaan-18.appspot.com/o/YFC_Logo_Large_PNG.png?alt=media&token=86bd0e80-1c48-4342-885a-afd1e8005dd0",
          "name": "YFC"
        }
      ],
      "3-Environment Partner": [
        {
          "link": "https://nerolac.com/home-paint/home-owner.html?siteid=Google&utm_source=Google_Search&utm_medium=CPC&utm_content=Text_Ad&utm_campaign=Brand_Exact_Desktop&gclid=CjwKCAiAtorUBRBnEiwAfcp_Yyv7f1ArPrYbGfLGJks8QecKP1itqxaDW50fnFFBZvsVoVD5K8Xl_hoCTtUQAvD_BwE",
          "logo": "https://firebasestorage.googleapis.com/v0/b/udaan-18.appspot.com/o/Nerolac%20Logo.png?alt=media&token=27c6cfce-2922-4d43-9739-4b5adee84c31",
          "name": "Nerolac"
        }
      ],
      "4-NGO": [
        {
          "link": "http://muskurahat.org.in/about.html",
          "logo": "https://firebasestorage.googleapis.com/v0/b/udaan-18.appspot.com/o/muskaan.png?alt=media&token=dae07128-0432-4e92-9e40-87590b21a3c2",
          "name": "Muskurahat Foundation"
        }
      ],
      "5-Degital Media": [
        {
          "link": "http://beingstudent.com",
          "logo": "https://firebasestorage.googleapis.com/v0/b/udaan-18.appspot.com/o/Being%20Student.png?alt=media&token=7ea8e870-344b-4d37-ac1a-0084644a8d9a",
          "name": "Being Student.com"
        }
      ],
      "6-Co Sponsor": [
        {
          "link": "https://www.indiatoday.in",
          "logo": "https://firebasestorage.googleapis.com/v0/b/udaan-18.appspot.com/o/INDIA_TODAY_TELEVISION_HI-RES.JPG?alt=media&token=b16c1d5c-6514-4d02-8748-1f8e6740ff85",
          "name": "India TV"
        }
      ]
    },
    "Timetable": {
      "url": "https://firebasestorage.googleapis.com/v0/b/udaan-18.appspot.com/o/udaan%20time%20table-ilovepdf-compressed%20(4).pdf?alt=media&token=a50384b3-9be0-4183-b134-bc214811a135"
    }
  }
}

```

> Added assets

Add loading screen, login screen etc as you want to.

> Ads

If you have access to an admob account then you can add banner and interstitial adds at certain places. In ``Firebase Constants`` files add your appIds for Ads.
