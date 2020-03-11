import StringIO,time,string,os

def main(FileName, Header, Sep):
        L=[]
        fr=open(FileName,'r')
        frm = ''.join(fr.readlines()).splitlines()
        for i in range(Header,len(frm)):
              line=frm[i]
              if(Sep==''):
                 line=frm[i].split()
              else:
                 line=frm[i].split(Sep)
              L.append(line)
        fr.close()
        return L              
                                                
if __name__ == '__main__':
        main()
