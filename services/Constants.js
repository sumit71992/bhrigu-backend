export const SocketEvent = {
  LIKE_POST_EVENT: "likePost",
  NEW_BOOKING: "newBooking",
  CONNECTED_EVENT: "connected",
  DISCONNECTED_EVENT: "disconnect",
  LIKE_COMMENT_EVENT: "likeComment",
  NEW_MESSAGE_EVENT: "newMessage",
  NEW_CHAT_EVENT: "newChat",
  COMMENT_POST_EVENT: "commentPost",
  SHARE_POST_EVENT: "sharePost",
  GROUP_MEMBER_ADDED:"groupMemberAdded",
  MENTIONED_YOU_IN_CHAT:"chatMention",
  ONLINE_USERS:"onlineUsers"
};
export const Constants = {
  CATERER:"CATERER",
  DINEIN:"DINEIN",
  FOOD:"FOOD",
  PENDING:"PENDING",
  CANCELLED:"CANCELLED",
  INPROGRESS:"INPROGRESS",
  REJECTED:"REJECTED",
  COMPLETED:"COMPLETED",
  CHAT_MENTION:"CHATMENTION",
  POST:"POST",
  DB_NAME:"chefwire",
  NEW_CHAT_CREATED:"NEWCHAT",
  ACTIVE:"ACTIVE",
  INACTIVE:"INACTIVE",
  OTP_TYPE_SIGNUP:"SIGNUP",
  OTP_TYPE_FORGOT:"FORGOTPASSWORD",
  OTP_SENT_MOBILE:"Otp sent successfully to your mobile number",
  OTP_SENT_EMAIL:"Otp sent successfully to your email",
  INVALID_OTP:"Entered otp is incorrect",
  USERNAME_EXIST:"User name already exists",
  USERNAME_AVAILABLE:"User name is available",
  OTP_EXPIRED:"Otp is expired",
  OTP_VERIFIED:"Otp verified successfully",
  BLOCKED:"BLOCKED",
  LOGOUT:"Logout Successful",
  LOGIN:"Login Successful",
  SIGNUP:"Signup Successful",
  EMAIL_EXIST:"Email already axist",
  MOBILE_EXIST:"Mobile number already axist",
  WRONG_EMAIL:"Email not exist please signup",
  WRONG_PASSWORD:"Password is incorrect",
  DATA_FETCHED:"Data fetched successfully",
  DATA_CREATED:"Data added successfully",
  DATA_UPDATED:"Data updated successfully",
  DATA_NOT_UPDATED:"Data not updated",
  DATA_DELETED:"Data deleted successfully",
  DATA_NOT_FETCHED:"Error while fetching data",
  DATA_NOT_CREATED:"Error while creating data",
  DATA_NOT_CREATED:"Error while creating data",
  DATA_EXIST:"Data already available with this name",
  DATA_NOT_DELETED:"Error while deleting data",
  INACTIVE_SIGNUP:"You are blocked please contact your administrator",
  SOMETHING_WRONG:"Something went wrong!",
  SOMETHINGWRONG:"Something went wrong",
  INCORRECT_PASSWORD:"Incorrect password",
  PASSWORD_CHANGED:"Password changed successfully",
  INVALID_TOKEN:"Please provide valid authentication token",
  INVALID_ID:"Please provide valid ID",
  ADD_ICON:"Please add a icon",
  NOT_AUTHORIZED:"You are not authorized to perform this action",
  LOGIN_SUCCESS:"Singin successful"
  
  };

export const ChatEventEnum = Object.freeze({
  // ? once user is ready to go
  CONNECTED_EVENT: "connected",
  // ? when user gets disconnected
  DISCONNECT_EVENT: "disconnect",
  // ? when user joins a socket room
  JOIN_CHAT_EVENT: "joinChat",
  // ? when participant gets removed from group, chat gets deleted or leaves a group
  LEAVE_CHAT_EVENT: "leaveChat",
  // ? when admin updates a group name
  UPDATE_GROUP_NAME_EVENT: "updateGroupName",
  // ? when new message is received
  MESSAGE_RECEIVED_EVENT: "messageReceived",
  // ? when there is new one on one chat, new group chat or user gets added in the group
  NEW_CHAT_EVENT: "newChat",
  // ? when there is an error in socket
  SOCKET_ERROR_EVENT: "socketError",
  // ? when participant stops typing
  STOP_TYPING_EVENT: "stopTyping",
  // ? when participant starts typing
  TYPING_EVENT: "typing",
});

export const AvailableChatEvents = Object.values(ChatEventEnum);
