@Posts = new Meteor.Collection('posts');
Schemas.Geocoords = new SimpleSchema
	lng:
		type:Number
		decimal: true
		min: -180
		max: 180

	lat:
		type:Number
		decimal: true
		min: -90
		max: 90

Schemas.Point = new SimpleSchema
	type:
		type:String
		autoValue:  ->
			"Point"
	coordinate:
		type: Schemas.Geocoords

Schemas.Polygon = new SimpleSchema
	type:
		type: String
		autoValue:  ->
			"Polygon"
	coordinates:
		type: [[Schemas.Geocoords]]

Schemas.Posts = new SimpleSchema
	title:
		type:String
		label:  ->
			TAPi18n.__ 'farmName'
		max: 60

	geometry:
		type: Schemas.Polygon

	content:
		type: String
		label:  ->
			TAPi18n.__ 'farmDescription'
		autoform:
			rows: 2

	createdAt: 
		type: Date
		autoValue: ->
			if this.isInsert
				new Date()

	updatedAt:
		type:Date
		optional:true
		autoValue: ->
			if this.isUpdate
				new Date()

	picture:
		type: String
		label:  ->
			TAPi18n.__ 'picture'
		autoform:
			afFieldInput:
				type: 'fileUpload'
				collection: 'Attachments'

	owner: 
		type: String
		regEx: SimpleSchema.RegEx.Id
		autoValue: ->
			if this.isInsert
				Meteor.userId()
		autoform:
			options: ->
				_.map Meteor.users.find().fetch(), (user)->
					label: user.emails[0].address
					value: user._id

Posts.attachSchema(Schemas.Posts)