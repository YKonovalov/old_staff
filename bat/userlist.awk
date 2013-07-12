BEGIN{FS=" ";br=tolower(br);}

!/\ +1]/&&!/\*\ /&&br~/b.*m/&&/\ 1[01]\]/{
 printf($2);
 printf("\t%s\n",substr($6,1,length($6)-1));
}

!/\ +1]/&&!/\*\ /&&br~/sm.*/&&/\ 2[012]\]/{
 printf($2);
 printf("\t%s\n",substr($6,1,length($6)-1));
}

!/\ +1]/&&!/\*\ /&&br~/pu.*/&&/\ 30\]/{
 printf($2);
 printf("\t%s\n",substr($6,1,length($6)-1));
}

!/\ +1]/&&!/\*\ /&&br~/pa.*/&&/\ 40\]/{
 printf($2);
 printf("\t%s\n",substr($6,1,length($6)-1));
}

!/\ +1]/&&!/\*\ /&&br~/sl.*/&&/\ 50\]/{
 printf($2);
 printf("\t%s\n",substr($6,1,length($6)-1));
}

!/\ +1]/&&!/\*\ /&&br~/st.*/&&/\ 60\]/{
 printf($2);
 printf("\t%s\n",substr($6,1,length($6)-1));
}

!/\ +1]/&&!/\*\ /&&br~/pp|pa.*k/&&/\ 70\]/{
 printf($2);
 printf("\t%s\n",substr($6,1,length($6)-1));
}

!/\ +1]/&&!/\*\ /&&br~/k[rh]/&&/\ 80\]/{
 printf($2);
 printf("\t%s\n",substr($6,1,length($6)-1));
}

/\*\ /{
 printf($3);
 printf("\t%s\n",substr($7,1,length($7)-1));
}
