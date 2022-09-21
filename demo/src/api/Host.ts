
      interface HostHooks {
        createComment: createComment
getComment: getComment
listComments: listComments
      }

      interface CommentRequest {
      contents: string
    }
interface  {
      statusCode: 200,id: string,contents: string,sentiment: string
    }
interface createComment {
      (comment: CommentRequest): Promise<>
    }
interface  {
      statusCode: 200,id: string,contents: string,sentiment: string
    }
interface getComment {
      (id: string): Promise<>
    }
interface Comment {
      id: string,contents: string,sentiment: string
    }
interface  {
      statusCode: 200,body: Comment[]
    }
interface listComments {
      (): Promise<>
    }

      export const Host: HostHooks = {} as any;
    