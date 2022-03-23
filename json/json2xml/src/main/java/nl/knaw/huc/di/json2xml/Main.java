/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.knaw.huc.di.json2xml;

import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XdmDestination;
import net.sf.saxon.s9api.XdmFunctionItem;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XdmValue;
import net.sf.saxon.s9api.XsltTransformer;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Collection;

import net.sf.saxon.s9api.XsltExecutable;
import nl.mpi.tla.util.Saxon;
import javax.xml.transform.stream.StreamSource;
import net.sf.saxon.s9api.XdmAtomicValue;

public class Main {

  public static void main(String[] args) throws SaxonApiException, IOException {
    try {
      String json="{\"id\":15229,\"identifier\":\"GGMA4T\"}";
      System.out.println("JSON["+ json + "]");
      XdmValue xml = Saxon.parseJson(json);
      System.out.println("XML["+xml.toString()+"]");
      Saxon.save(((XdmNode)xml).asSource(), new File("out.xml"));
    } catch (Exception e) {
        System.err.println("!ERR:"+e.getMessage());
        e.printStackTrace();
    }
  }
}