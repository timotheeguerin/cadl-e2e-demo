
      interface HostHooks {
        createComment: createComment
getComment: getComment
listComments: listComments
      }

      interface CommentRequest {
      contents: string
    }
interface Comment {
      id: string,contents: string,sentiment: string
    }
interface OkComment {
      statusCode: 200,body: Comment
    }
interface createComment {
      (comment: CommentRequest): Promise<OkComment>
    }
interface getComment {
      (id: string): Promise<OkComment>
    }
interface OkCommentArray {
      statusCode: 200,body: Comment[]
    }
interface listComments {
      (): Promise<OkCommentArray>
    }

      export const Host: HostHooks = {} as any;
    