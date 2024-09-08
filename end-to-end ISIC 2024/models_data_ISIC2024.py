from sqlalchemy import Column, Integer, String, Float
from database import Base

    
class ISICData(Base):
    __tablename__ = "list_patient"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True) #, primary_key=True)
    diagnose = Column(Integer, index=True)