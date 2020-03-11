from IPython.display import HTML, display
import tabulate
import sys

def read(FileName, Sep):
        L=[]
        fr=open(FileName,'r')
        frm = ''.join(fr.readlines()).splitlines()
        for i in range(0,len(frm)):
              line=frm[i]
              if(Sep==''):
                 line=frm[i].split()
              else:
                 line=frm[i].split(Sep)
              L.append(line)
        fr.close()
        return L
def wf(FileName, L,Sep,colwidth):
        
        fw=open(FileName,'w')
        L1=[]
        for k in range (len(L)):
            line=L[k]
#            
                
            fw.write("%40s\t%20s\t%20s\n"%(line[0],line[1],line[2]))
            
        fw.close()          
f="../Tests/comprision_two_mice.txt"
sep="\t"
table=read(f,sep)
fw=f+'.4display.txt'
colwidth=[50,40,40]
wf(fw,table,'\t',colwidth)
print HTML(tabulate.tabulate(table, tablefmt='html'))