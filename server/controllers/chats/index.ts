import { Request, Response } from "express";
import HasuraMutation from "../../hasura_queries/mutation";
import HasuraHelper from "../../helpers/hasura/hasura";

const sendChat = async (req: Request, res: Response) => {
  try {
    let { sender_id, receiver_id, message } = req.body;
    let response =await HasuraHelper.getInstance().query(HasuraMutation.sendChat(message,sender_id,receiver_id));
    
    if(response['insert_chats']['affected_rows']>=1){
        res.json({
            "status":"success",
            "id":response['insert_chats']['returning'][0]['id']
        });
    }
    else{
        throw new Error("message was not send");
    }
    
  } catch (e: any) {
    res.status(401).json({
      error: e.message,
    });
  }
};


export default {sendChat};